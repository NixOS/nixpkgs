{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
}:

rustPlatform.buildRustPackage rec {
  pname = "ripdrag";
  version = "0.4.11";

  src = fetchFromGitHub {
    owner = "nik012003";
    repo = "ripdrag";
    rev = "v${version}";
    hash = "sha256-1IUS0PNzIoSrlBXQrUmw/lXUD8auVVKhu/irSoYoK6w=";
  };

  cargoHash = "sha256-LtkSGu261rPFgofaD/t2rSilxUPL6eHBpd/Tz9gR8ZM=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [ gtk4 ];

  meta = with lib; {
    description = "Application that lets you drag and drop files from and to the terminal";
    homepage = "https://github.com/nik012003/ripdrag";
    changelog = "https://github.com/nik012003/ripdrag/releases/tag/${src.rev}";
    license = licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "ripdrag";
  };
}
