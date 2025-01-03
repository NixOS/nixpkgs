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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = "hdr10plus_tool";
    rev = "refs/tags/${version}";
    hash = "sha256-EyKCdrilb6Ha9avEe5L4Snbufq8pEiTvr8tcdj0M6Zs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "plotters-0.3.5" = "sha256-cz8/chdq8C/h1q5yFcQp0Rzg89XHnQhIN1Va52p6Z2Y=";
    };
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
