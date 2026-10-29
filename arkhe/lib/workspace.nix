# Fonte mínima por pacote a partir do workspace Cargo.
#
# Cada pacote recebe só os crates do seu fecho de dependências `path`
# (lido dos Cargo.toml na avaliação), os Cargo.toml de todos os outros crates
# (o Cargo precisa deles para carregar o workspace e validar o Cargo.lock) e
# os arquivos fora do crate lidos em tempo de compilação (`crateExtras`).
# Assim, editar um crate fora do fecho não muda o hash da fonte do pacote.
#
# Os crates fora do fecho recebem alvos vazios em `postPatch` (`stubs`):
# o Cargo exige que todo membro do workspace tenha ao menos um alvo, mas
# nunca os compila, porque os builds usam `-p <crate>`.
{ lib }:

{
  root,
  # nome do crate -> caminhos relativos à raiz lidos por include_str!,
  # include_bytes! ou sqlx::migrate! fora do diretório do crate.
  crateExtras ? { },
}:

let
  fs = lib.fileset;

  rootStr = toString root;
  rootManifest = lib.importTOML (root + "/Cargo.toml");
  workspaceDeps = rootManifest.workspace.dependencies or { };

  # "a/b/../c" -> "a/c"
  normalize =
    path:
    lib.concatStringsSep "/" (
      lib.foldl' (
        acc: seg:
        if seg == "" || seg == "." then
          acc
        else if seg == ".." then
          (if acc == [ ] then throw "nixpkgs-arkhe: caminho sai do workspace: ${path}" else lib.init acc)
        else
          acc ++ [ seg ]
      ) [ ] (lib.splitString "/" path)
    );

  manifestFiles = fs.fileFilter (file: file.name == "Cargo.toml") root;

  crateDirs = lib.filter (dir: dir != "") (
    map (file: lib.removePrefix "/" (lib.removePrefix rootStr (toString (dirOf file)))) (
      fs.toList manifestFiles
    )
  );

  manifestOf = dir: lib.importTOML (root + "/${dir}/Cargo.toml");

  nameOf = dir: (manifestOf dir).package.name;

  dirByName = lib.listToAttrs (map (dir: lib.nameValuePair (nameOf dir) dir) crateDirs);

  dirOfCrate =
    name: dirByName.${name} or (throw "nixpkgs-arkhe: crate `${name}` não existe no workspace");

  # Diretórios (relativos à raiz) das dependências `path` de um crate.
  # Inclui tabelas `[target.'cfg(..)'.*]`: o superconjunto é seguro.
  pathDepsOf =
    withDev: dir:
    let
      manifest = manifestOf dir;
      sections = [
        "dependencies"
        "build-dependencies"
      ] ++ lib.optional withDev "dev-dependencies";
      tablesOf = t: map (section: t.${section} or { }) sections;
      tables = tablesOf manifest ++ lib.concatMap tablesOf (lib.attrValues (manifest.target or { }));
      depPath =
        name: spec:
        if !(builtins.isAttrs spec) then
          [ ]
        else if spec.workspace or false then
          let
            ws = workspaceDeps.${name} or { };
          in
          lib.optional (builtins.isAttrs ws && ws ? path) (normalize ws.path)
        else
          lib.optional (spec ? path) (normalize "${dir}/${spec.path}");
    in
    lib.concatMap (table: lib.concatLists (lib.mapAttrsToList depPath table)) tables;

  # `testCrates` também trazem dev-dependencies; dependências transitivas não.
  closureOf =
    { crates, testCrates }:
    map (item: item.key) (
      builtins.genericClosure {
        startSet =
          map (name: {
            key = dirOfCrate name;
            dev = true;
          }) testCrates
          ++ map (name: {
            key = dirOfCrate name;
            dev = false;
          }) crates;
        operator =
          item:
          map (dir: {
            key = dir;
            dev = false;
          }) (pathDepsOf item.dev item.key);
      }
    );

  # Alvos que o Cargo procura ao carregar um manifesto.
  stubTargetsOf =
    dir:
    let
      manifest = manifestOf dir;
      named = kind: defaultDir: map (t: t.path or "${defaultDir}/${t.name}.rs") (manifest.${kind} or [ ]);
      build = manifest.package.build or null;
      # `default-run` precisa apontar para um binário existente.
      defaultRun = manifest.package.default-run or null;
      declaredBins = map (t: t.name) (manifest.bin or [ ]);
      defaultRunTarget =
        if defaultRun == null || lib.elem defaultRun declaredBins then
          [ ]
        else if defaultRun == manifest.package.name then
          [ "src/main.rs" ]
        else
          [ "src/bin/${defaultRun}.rs" ];
    in
    [ (manifest.lib.path or "src/lib.rs") ]
    ++ defaultRunTarget
    ++ named "bin" "src/bin"
    ++ named "test" "tests"
    ++ named "bench" "benches"
    ++ named "example" "examples"
    ++ lib.optional (builtins.isString build) build;
in
{
  inherit crateDirs;

  sourceFor =
    {
      crates ? [ ],
      testCrates ? [ ],
    }:
    let
      closure = closureOf { inherit crates testCrates; };
      closureNames = map nameOf closure;
      extras = lib.unique (lib.concatMap (name: crateExtras.${name} or [ ]) closureNames);
      stubs = lib.concatMap (dir: map (target: "${dir}/${target}") (stubTargetsOf dir)) (
        lib.subtractLists closure crateDirs
      );
    in
    {
      inherit closure closureNames;

      lockFile = root + "/Cargo.lock";

      src = fs.toSource {
        inherit root;
        fileset = fs.unions (
          [
            (root + "/Cargo.toml")
            (root + "/Cargo.lock")
            manifestFiles
          ]
          ++ map (dir: root + "/${dir}") closure
          ++ map (path: root + "/${path}") extras
        );
      };

      postPatch = lib.concatMapStrings (stub: ''
        if [ ! -e ${lib.escapeShellArg stub} ]; then
          mkdir -p "$(dirname ${lib.escapeShellArg stub})"
          : > ${lib.escapeShellArg stub}
        fi
      '') stubs;
    };
}
