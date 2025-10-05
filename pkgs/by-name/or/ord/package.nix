{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "ord";
  version = "0.23.3";

  src = fetchFromGitHub {
    owner = "ordinals";
    repo = "ord";
    rev = version;
    hash = "sha256-+e5l+ez/cDqoyqF05jv6bs1l82pHTMtGFdMEtUln/qM=";
  };

  cargoHash = "sha256-LPClIma05n+e+mDy0ycaap84yzmDR+VnrT3RqGnfBLA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  dontUseCargoParallelTests = true;

  checkFlags = [
    "--skip=subcommand::server::tests::status" # test fails if it built from source tarball
  ];

  meta = with lib; {
    description = "Index, block explorer, and command-line wallet for Ordinals";
    homepage = "https://github.com/ordinals/ord";
    changelog = "https://github.com/ordinals/ord/blob/${src.rev}/CHANGELOG.md";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "ord";
  };
}
