{
  lib,
  stdenvNoCC,
  runCommand,
  writers,
  python3Packages,
  cargo,
  nix-prefetch-git,
  cacert,
}:

let
  replaceWorkspaceValues = writers.writePython3Bin "replace-workspace-values" {
    libraries = with python3Packages; [
      tomli
      tomli-w
    ];
    flakeIgnore = [
      "E501"
      "W503"
    ];
  } (builtins.readFile ../replace-workspace-values.py);

  fetchCargoVendor-create-staging =
    runCommand "fetch-cargo-vendor-create-staging"
      {
        buildInputs = [ (python3Packages.python.withPackages (ps: [ ps.requests ])) ];
      }
      ''
        baseDir="$out/share/fetch-cargo-vendor"
        install -Dm644 ${./common.py} "$baseDir/common.py"
        install -Dm755 ${./create-staging.py} "$baseDir/create-staging.py"
        mkdir -p "$out/bin"
        ln -s "$baseDir/create-staging.py" "$out/bin/fcv-create-staging"
        patchShebangs "$baseDir/create-staging.py"
      '';

  fetchCargoVendor-create =
    runCommand "fetch-cargo-vendor-create"
      {
        buildInputs = [ python3Packages.python ];
      }
      ''
        baseDir="$out/share/fetch-cargo-vendor"
        install -Dm644 ${./common.py} "$baseDir/common.py"
        install -Dm755 ${./create.py} "$baseDir/create.py"
        mkdir -p "$out/bin"
        ln -s "$baseDir/create.py" "$out/bin/fcv-create"
        patchShebangs "$baseDir/create.py"
      '';

in

{
  name ? if args ? pname && args ? version then "${args.pname}-${args.version}" else "cargo-deps",
  hash ? (throw "fetchCargoVendor requires a `hash` value to be set for ${name}"),
  nativeBuildInputs ? [ ],
  # This is mostly for breaking infinite recursion where dependencies
  # of nix-prefetch-git use fetchCargoVendor.
  allowGitDependencies ? true,
  ...
}@args:

# TODO: add asserts about pname version and name

let
  removedArgs = [
    "name"
    "pname"
    "version"
    "nativeBuildInputs"
    "hash"
  ];

  vendorStaging = stdenvNoCC.mkDerivation (
    {
      name = "${name}-vendor-staging";

      nativeBuildInputs =
        [
          fetchCargoVendor-create-staging
          cacert
        ]
        ++ lib.optionals allowGitDependencies [
          nix-prefetch-git
        ]
        ++ nativeBuildInputs;

      buildPhase = ''
        runHook preBuild

        if [ -n "''${cargoRoot-}" ]; then
          cd "$cargoRoot"
        fi

        fcv-create-staging ./Cargo.lock "$out"

        runHook postBuild
      '';

      dontInstall = true;
      dontFixup = true;

      outputHash = hash;
      outputHashAlgo = if hash == "" then "sha256" else null;
      outputHashMode = "recursive";
    }
    // builtins.removeAttrs args removedArgs
  );
in

runCommand "${name}-vendor"
  {
    inherit vendorStaging;
    nativeBuildInputs = [
      fetchCargoVendor-create
      cargo
      replaceWorkspaceValues
    ];
  }
  ''
    fcv-create "$vendorStaging" "$out"
  ''
