{
  lib,
  rustPlatform,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  libgit2,
  openssl,
  stdenv,
  zlib,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "ghr";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "siketyan";
    repo = "ghr";
    rev = "v${version}";
    hash = "sha256-L9+rcdt+MGZSCOJyCE4t/TT6Fjtxvfr9LBJYyRrx208=";
  };

  cargoHash = "sha256-xRa/brOYJ19J25wGdtNR2g+ouMyvz9YFXnzepeipWNQ=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
    zstd
  ];

  postInstall =
    let
      ghr = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/ghr";
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      installShellCompletion --cmd ghr \
        --bash <(${ghr} shell --completion bash) \
        --fish <(${ghr} shell --completion fish)
    '';

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "Yet another repository management with auto-attaching profiles";
    homepage = "https://github.com/siketyan/ghr";
    license = licenses.mit;
    maintainers = with maintainers; [ sei40kr ];
    mainProgram = "ghr";
  };
}
