{
  lib,
  stdenvNoCC,
  runCommand,
  writers,
  python3Packages,
  cargo,
  gitMinimal,
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

  nix-prefetch-git' = nix-prefetch-git.override {
    git = gitMinimal;
    # break loop of nix-prefetch-git -> git-lfs -> asciidoctor -> ruby (yjit) -> fetchCargoVendor -> nix-prefetch-git
    # Cargo does not currently handle git-lfs: https://github.com/rust-lang/cargo/issues/9692
    git-lfs = null;
  };

  removedArgs = [
    "name"
    "pname"
    "version"
    "nativeBuildInputs"
    "hash"
  ];

  mkFetchCargoVendorUtil =
    name: src:
    writers.writePython3Bin name {
      libraries =
        with python3Packages;
        [
          requests
          tomli-w
        ]
        ++ requests.optional-dependencies.socks; # to support socks proxy envs like ALL_PROXY in requests
      flakeIgnore = [
        "E501"
      ];
    } (builtins.readFile src);

  # Separate util used only by the FOD `vendorStaging` stage below. Kept
  # distinct from fetchCargoVendorUtil so that changes to the network-facing
  # bits (User-Agent, download URL) don't invalidate the input-addressed
  # `-vendor` stage and force a mass rebuild of every Rust package in nixpkgs.
  # vendorStaging is an FOD, so swapping its util is free for consumers.
  # TODO: unify with fetchCargoVendorUtil on the next `staging` cycle.
  fetchCargoVendorUtilV2 = mkFetchCargoVendorUtil "fetch-cargo-vendor-util-v2" ./fetch-cargo-vendor-util-v2.py;
  fetchCargoVendorUtil = mkFetchCargoVendorUtil "fetch-cargo-vendor-util" ./fetch-cargo-vendor-util.py;
in

{
  name ? if args ? pname && args ? version then "${args.pname}-${args.version}" else "cargo-deps",
  hash ? (throw "fetchCargoVendor requires a `hash` value to be set for ${name}"),
  nativeBuildInputs ? [ ],
  ...
}@args:

# TODO: add asserts about pname version and name

let
  vendorStaging = stdenvNoCC.mkDerivation (
    {
      name = "${name}-vendor-staging";

      impureEnvVars = lib.fetchers.proxyImpureEnvVars;

      nativeBuildInputs = [
        fetchCargoVendorUtilV2
        cacert
        nix-prefetch-git'
      ]
      ++ nativeBuildInputs;

      buildPhase = ''
        runHook preBuild

        if [ -n "''${cargoRoot-}" ]; then
          cd "$cargoRoot"
        fi

        fetch-cargo-vendor-util-v2 create-vendor-staging ./Cargo.lock "$out"

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
