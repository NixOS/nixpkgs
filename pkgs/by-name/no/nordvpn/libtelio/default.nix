{
  cmake,
  fetchFromGitHub,
  git,
  lib,
  libpcap,
  llvmPackages,
  pkg-config,
  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libtelio";
  version = "6.2.4";

  src = fetchFromGitHub {
    owner = "NordSecurity";
    repo = "libtelio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0vqe3Ilm6Boc1aBjIzAmrL9RK1UMksVnt6AvjwUM+NQ=";
  };

  nativeBuildInputs = [
    cmake # needed by aws-lc-sys
    git # needed by neptun
    pkg-config
    protobuf
    rustPlatform.bindgenHook # needed by aws-lc-sys
  ];

  buildInputs = [
    llvmPackages.libclang.lib # needed by aws-lc-sys
    libpcap # needed by neptun
  ];

  cargoHash = "sha256-9sbWBAo+Ok+2g9srI/loN1Rwv75Qi5xFCmJHBooekKs=";

  # skip p2p network tests that won't run inside a nix sandbox
  cargoTestFlags = [
    "--"
    "--skip=device::tests::test_default_features_when_provider_is_empty"
    "--skip=device::tests::test_default_features_when_direct_is_empty"
    "--skip=device::tests::test_enable_all_direct_features"
  ];

  patches = [
    ./libtelio.patch
  ];

  cargoPatches = [
    ./llt-proto-rev.patch
  ];

  postPatch = ''
    patchShebangs test_runner.sh
  '';

  env = {
    BYPASS_LLT_SECRETS = "1";
  };

  doCheck = true;

  meta = {
    description = "A P2P networking library used by NordVPN.";
    homepage = "https://github.com/NordSecurity/libtelio";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      different-error
      novalkun
    ];
    platforms = lib.platforms.linux;
  };
})
