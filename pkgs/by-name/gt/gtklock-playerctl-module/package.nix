{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gtk3,
  playerctl,
  libsoup_3,
  gtklock,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtklock-playerctl-module";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = "gtklock-playerctl-module";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YlnZxp06Bb8eIgZhCvbiX6jgnNuGoSv4wx0N4AD1V7o=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gtk3
    playerctl
    libsoup_3
  ];

  passthru.tests.testModule = gtklock.testModule finalAttrs.finalPackage;

  meta = {
    description = "Gtklock module adding media player controls to the lockscreen";
    homepage = "https://github.com/jovanlanik/gtklock-playerctl-module";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
