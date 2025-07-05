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

  useFetchCargoVendor = true;
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
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/ghr"
        else
          lib.getExe buildPackages.siketyan-ghr;
    in
    ''
      installShellCompletion --cmd ghr \
        --bash <(${exe} shell --completion bash) \
        --fish <(${exe} shell --completion fish)
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
