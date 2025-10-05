{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  openssl,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "boa";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "boa-dev";
    repo = "boa";
    tag = "v${version}";
    hash = "sha256-foCIzzFoEpcE6i0QrSbiob3YHIOeTpjwpAMtcPGL8Vg=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-PphgRSVCj724eYAC04Orpz/klYuAhphiQ3v5TRChs+w=";

  cargoBuildFlags = [
    "--package"
    "boa_cli"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    bzip2
    openssl
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "Embeddable and experimental Javascript engine written in Rust";
    mainProgram = "boa";
    homepage = "https://github.com/boa-dev/boa";
    changelog = "https://github.com/boa-dev/boa/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      unlicense
    ];
    maintainers = with maintainers; [ dit7ya ];
  };
}
