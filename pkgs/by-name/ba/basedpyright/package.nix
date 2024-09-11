{
  lib,
  fetchFromGitHub,
  runCommand,
  jq,
  buildNpmPackage,
  python3,
  stdenvNoCC,
  testers,
  basedpyright,
}:

let
  version = "1.17.4";

  src = fetchFromGitHub {
    owner = "detachhead";
    repo = "basedpyright";
    rev = "refs/tags/v${version}";
    hash = "sha256-7lJUyn7UAY+wdbPXcLFz54m2Jl90EMZ6ieSPWysMoWE=";
  };

  patchedPackageJSON = runCommand "package.json" { } ''
    ${jq}/bin/jq '
      .devDependencies |= with_entries(select(.key == "glob" or .key == "jsonc-parser"))
      | .scripts =  {  }
      ' ${src}/package.json > $out
  '';

  pyright-root = buildNpmPackage {
    pname = "pyright-root";
    inherit version src;
    npmDepsHash = "sha256-63kUhKrxtJhwGCRBnxBfOFXs2ARCNn+OOGu6+fSJey4=";
    dontNpmBuild = true;
    postPatch = ''
      cp ${patchedPackageJSON} ./package.json
      cp ${./package-lock.json} ./package-lock.json
    '';
    installPhase = ''
      runHook preInstall
      cp -r . "$out"
      runHook postInstall
    '';
  };

  pyright-internal = buildNpmPackage {
    pname = "pyright-internal";
    inherit version src;
    sourceRoot = "${src.name}/packages/pyright-internal";
    npmDepsHash = "sha256-hd85cCpxx0vqtUXDUorHK8I9IbGZiwewI/RxKF/9ZNw=";
    dontNpmBuild = true;
    # Uncomment this flag when using unreleased peer dependencies
    # npmFlags = [ "--legacy-peer-deps" ];
    installPhase = ''
      runHook preInstall
      cp -r . "$out"
      runHook postInstall
    '';
  };

  docify = python3.pkgs.buildPythonApplication {
    pname = "docify";
    version = "unstable";
    format = "pyproject";
    src = fetchFromGitHub {
      owner = "AThePeanut4";
      repo = "docify";
      rev = "7380a6faa6d1e8a3dc790a00254e6d77f84cbd91";
      hash = "sha256-BPR1rc/JzdBweiWmdHxgardDDrJZVWkUIF3ZEmEYf/A=";
    };
    buildInputs = [ python3.pkgs.setuptools ];
    propagatedBuildInputs = [
      python3.pkgs.libcst
      python3.pkgs.tqdm
    ];
  };

  docstubs = stdenvNoCC.mkDerivation {
    name = "docstubs";
    inherit src;
    buildInputs = [ docify ];

    installPhase = ''
      runHook preInstall
      cp -r packages/pyright-internal/typeshed-fallback docstubs
      ${docify}/bin/docify docstubs/stdlib --builtins-only --in-place
      cp -rv docstubs "$out"
      runHook postInstall
    '';
  };
in
buildNpmPackage rec {
  pname = "basedpyright";
  inherit version src;

  sourceRoot = "${src.name}/packages/pyright";
  npmDepsHash = "sha256-UKxFWhgarMdT24rFU5Ev+JoKbT6ByLnZ1CTKd34YrRE=";

  postPatch = ''
    chmod +w ../../
    ln -s ${docstubs} ../../docstubs
    ln -s ${pyright-root}/node_modules ../../node_modules
    chmod +w ../pyright-internal
    ln -s ${pyright-internal}/node_modules ../pyright-internal/node_modules
  '';

  postInstall = ''
    mv "$out/bin/pyright" "$out/bin/basedpyright"
    mv "$out/bin/pyright-langserver" "$out/bin/basedpyright-langserver"
  '';

  dontNpmBuild = true;

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion { package = basedpyright; };
  };

  meta = {
    changelog = "https://github.com/detachhead/basedpyright/releases/tag/${version}";
    description = "Type checker for the Python language";
    homepage = "https://github.com/detachhead/basedpyright";
    license = lib.licenses.mit;
    mainProgram = "basedpyright";
    maintainers = with lib.maintainers; [ kiike ];
  };
}
