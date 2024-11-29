{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gtk3,
  glib,
  accountsservice,
  gtklock,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtklock-userinfo-module";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = "gtklock-userinfo-module";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d9S0Tj7aII2JQ5/PZmt8HaUIb5caoD4GND0PGvuRMn8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gtk3
    glib
    accountsservice
  ];

  passthru.tests.testModule = gtklock.testModule finalAttrs.finalPackage;

  meta = {
    description = "Gtklock module adding user info to the lockscreen";
    homepage = "https://github.com/jovanlanik/gtklock-userinfo-module";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
