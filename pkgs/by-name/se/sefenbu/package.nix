{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland,
  alsa-lib,
  udev,
}:

rustPlatform.buildRustPackage {
  pname = "sefenbu";
  version = "unstable-2025-04-24";

  src = fetchFromGitHub {
    owner = "xiaoshihou514";
    repo = "sefenbu";
    rev = "6c7b95fdd58ad6e94352256a9499242126816516";
    hash = "sha256-K05+JruONbYnJwhsB9k61wzQgQDOeMAZrNHrgAUDXlk=";
  };

  cargoHash = "sha256-TiaN8qasK40c/3t3R9RKubJ2WFEEwcS5fGMiFmeVF80=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    wayland
    alsa-lib
    udev
  ];

  meta = {
    description = "Visualizes color distribution for an image";
    homepage = "https://github.com/xiaoshihou514/sefenbu";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pasqui23 ];
    mainProgram = "sefenbu";
  };
}
