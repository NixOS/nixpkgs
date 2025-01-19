{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
  libusbp,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pololu-jrk-g2-software";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "pololu";
    repo = "pololu-jrk-g2-software";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-CNXExdA0hKfZFCgLHQ7uNWwpHKggewwdb5shnFjM5L4=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    libsForQt5.qtbase
    libusbp
  ];

  postInstall = ''
    install -Dt $out/lib/udev/rules.d ../udev-rules/99-pololu.rules
  '';

  meta = {
    description = "Software and drivers for the Pololu Jrk G2 USB Motor Controllers with Feedback";
    homepage = "https://github.com/pololu/pololu-jrk-g2-software";
    license = with lib.licenses; [
      zlib
      mit
      gpl3Only
    ];
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "jrk2gui";
    platforms = lib.platforms.linux;
  };
})
