{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  fontconfig,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "hdr10plus_tool";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = "hdr10plus_tool";
    rev = "refs/tags/${version}";
    hash = "sha256-eP77LHADP9oenMACctPKU6xPzg4atC0dPOqyrFse/1s=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fontconfig ];

  passthru = {
    updateScript = nix-update-script { };
  };

  doCheck = false;

  meta = with lib; {
    description = "CLI utility to work with HDR10+ in HEVC files.";
    homepage = "https://github.com/quietvoid/hdr10plus_tool";
    changelog = "https://github.com/quietvoid/hdr10plus_tool/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ johnrtitor ];
    mainProgram = "hdr10plus_tool";
  };
}
