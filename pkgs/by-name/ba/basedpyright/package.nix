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
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "detachhead";
    repo = "basedpyright";
    rev = "refs/tags/v${version}";
    hash = "sha256-x4hSzkVDTbF6CyJttTLbZmnA3Ccs3k9mW90lp2Krk6E=";
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
    npmDepsHash = "sha256-Kg2y+z1izv3KV83UdUqEdyd8m0geMseb8uSb6tv4c5o=";
    dontNpmBuild = true;
    # FIXME: Remove this flag when TypeScript 5.5 is released
    npmFlags = [ "--legacy-peer-deps" ];
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
  npmDepsHash = "sha256-0zLSTePWvf3ZB6OE3cmjimYuAkoCmQ0besM2PiEEWao=";

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
