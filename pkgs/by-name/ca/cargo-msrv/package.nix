{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  rustup,
  openssl,
  stdenv,
  makeWrapper,
  gitUpdater,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-msrv";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = "cargo-msrv";
    tag = "v${version}";
    sha256 = "sha256-cRdnx9K+EkVEKtPxQk+gXK6nkgkpWhpYij/5e7pFzMU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-D35koQEqHsmXIBgXRCyI8Wyo2OVSuTFCjgm/JjO4VDo=";

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = ".(rc|beta).*";
    };
  };

  # Integration tests fail
  doCheck = false;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  # Depends at run-time on having rustup in PATH
  postInstall = ''
    wrapProgram $out/bin/cargo-msrv --prefix PATH : ${lib.makeBinPath [ rustup ]};
  '';

  meta = with lib; {
    description = "Cargo subcommand \"msrv\": assists with finding your minimum supported Rust version (MSRV)";
    mainProgram = "cargo-msrv";
    homepage = "https://github.com/foresterre/cargo-msrv";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      otavio
      matthiasbeyer
    ];
  };
}
