{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  libiio,
  libevdev,
}:

rustPlatform.buildRustPackage rec {
  pname = "inputplumber";
  version = "0.35.2";

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "InputPlumber";
    rev = "refs/tags/v${version}";
    hash = "sha256-O2l5VNfkXpsqmGZzC0wq6FbBhhNvO3qFluWcgDp4EKk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "evdev-0.12.2" = "sha256-OUU7QQnC3sgq0WwlWrm+ymustTtAoNqXhoZ/wixcgeY=";
      "virtual-usb-0.1.0" = "sha256-jgJM0aHA7Iz7nUjfjVg3mZo0kQKsDw0CgQaK820A1vw=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    udev
    libevdev
    libiio
  ];

  postInstall = ''
    cp -r rootfs/usr/* $out/
  '';

  meta = {
    description = "Open source input router and remapper daemon for Linux";
    homepage = "https://github.com/ShadowBlip/InputPlumber";
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/ShadowBlip/InputPlumber/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ shadowapex ];
    mainProgram = "inputplumber";
  };
}
