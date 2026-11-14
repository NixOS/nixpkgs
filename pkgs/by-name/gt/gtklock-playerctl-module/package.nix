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
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = "gtklock-playerctl-module";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+O3sZR0BA/EU5yFss0iDT+r6j7Zz4nKJdfymOE/nudg=";
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
