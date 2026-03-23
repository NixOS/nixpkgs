{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  gtklock,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtklock-virtkb-module";
  version = "0-unstable-2025-02-27";

  src = fetchFromGitHub {
    owner = "progandy";
    repo = "gtklock-virtkb-module";
    rev = "a11c2d8f14a79f271b02711b38220f927bc7fdf8";
    hash = "sha256-+kEv5SlMINCORQQOOZ4Lb1dSJXLCbX2oAsD6NTbuhdE=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk3
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru.tests.testModule = gtklock.passthru.testModule finalAttrs.finalPackage;

  meta = {
    description = "Gtklock module adding a keyboard to the lockscreen";
    homepage = "https://github.com/progandy/gtklock-virtkb-module";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
