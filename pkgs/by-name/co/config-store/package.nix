{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "config-store";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "DOD-101";
    repo = "config-store";
    tag = "v${version}";
    hash = "sha256-dmFIB9tVI5/hnI+VKeawFzKi6UJrRis0tpeQE5a5dGU=";
  };

  cargoHash = "sha256-tEhk6vDan5uaP1vvKanB+juKsGJndrJPP67kudds24s=";

  meta = {
    description = "Simple key-value store designed to be used from shell scripts written in Rust";
    homepage = "https://github.com/DOD-101/config-store";
    mainProgram = "config-store";
    license = with lib.licenses; [
      mit
      asl20
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dod-101 ];
  };
}
