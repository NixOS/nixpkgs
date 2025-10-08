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
    libraries =
      with python3Packages;
      [
        requests
      ]
      ++ requests.optional-dependencies.socks; # to support socks proxy envs like ALL_PROXY in requests
    flakeIgnore = [
      "E501"
    ];
  } (builtins.readFile ./fetch-cargo-vendor-util.py);
in

{
  name ? if args ? pname && args ? version then "${args.pname}-${args.version}" else "cargo-deps",
  hash ? (throw "fetchCargoVendor requires a `hash` value to be set for ${name}"),
  nativeBuildInputs ? [ ],
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

      impureEnvVars = lib.fetchers.proxyImpureEnvVars;

      nativeBuildInputs = [
        fetchCargoVendorUtil
        cacert
        # break loop of nix-prefetch-git -> git-lfs -> asciidoctor -> ruby (yjit) -> fetchCargoVendor -> nix-prefetch-git
        # Cargo does not currently handle git-lfs: https://github.com/rust-lang/cargo/issues/9692
        (nix-prefetch-git.override { git-lfs = null; })
      ]
      ++ nativeBuildInputs;

      buildPhase = ''
        runHook preBuild

        if [ -n "''${cargoRoot-}" ]; then
          cd "$cargoRoot"
        fi

        fetch-cargo-vendor-util create-vendor-staging ./Cargo.lock "$out"

        runHook postBuild
      '';

      strictDeps = true;

      dontConfigure = true;
      dontInstall = true;
      dontFixup = true;

      outputHash = hash;
      outputHashAlgo = if hash == "" then "sha256" else null;
      outputHashMode = "recursive";
    }
    // removeAttrs args removedArgs
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
