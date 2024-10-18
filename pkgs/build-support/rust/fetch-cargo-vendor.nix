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
  } (builtins.readFile ./replace-workspace-values.py);

  fetchCargoVendorUtil = writers.writePython3Bin "fetch-cargo-vendor-util" {
    libraries = with python3Packages; [
      tomli
      requests
    ];
    flakeIgnore = [
      "E501"
    ];
  } (builtins.readFile ./fetch-cargo-vendor-util.py);
in

{
  name ? if args ? pname && args ? version then "${args.pname}-${args.version}" else "cargo-deps",
  hash ? lib.fakeHash,
  nativeBuildInputs ? [ ],
  ...
}@args:

# TODO: add asserts

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

      nativeBuildInputs = [
        fetchCargoVendorUtil
        nix-prefetch-git
        cacert
      ] ++ nativeBuildInputs;

      buildPhase = ''
        runHook preBuild

        fetch-cargo-vendor-util create-vendor-staging ./Cargo.lock "$out"

        runHook postBuild
      '';

      dontInstall = true;
      dontFixup = true;

      outputHash = hash;
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    }
    // builtins.removeAttrs args removedArgs
  );
in

runCommand "${name}-vendor"
  {
    inherit vendorStaging;
    nativeBuildInputs = [
      fetchCargoVendorUtil
      cargo
      replaceWorkspaceValues
    ];
  }
  ''
    fetch-cargo-vendor-util create-vendor "$vendorStaging" "$out"
  ''
