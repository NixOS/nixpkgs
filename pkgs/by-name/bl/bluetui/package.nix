{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage rec {
  pname = "bluetui";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "bluetui";
    rev = "v${version}";
    hash = "sha256-8X1kr0GPY/DqGZb1hJ52OkmgtYk0giwTeoqWTN0ZEbI=";
  };

  cargoHash = "sha256-CQFjauJ/y7XWZob/8gRQszKjBbkSdIt5l5OlSKVKoMw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  postInstall = ''
    install -Dm444 bluetui.desktop -t $out/share/applications
  '';

  meta = {
    description = "TUI for managing bluetooth on Linux";
    homepage = "https://github.com/pythops/bluetui";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      donovanglover
      matthiasbeyer
    ];
    mainProgram = "bluetui";
    platforms = lib.platforms.linux;
  };
}
