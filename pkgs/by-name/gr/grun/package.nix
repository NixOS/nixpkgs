{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk2,
  pkg-config,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "grun";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "lrgc";
    repo = "grun";
    rev = "release_0_9_3";
    hash = "sha256-VbvX0wrgMIPmPnu3aQdtQ6H0X3umi8aJ42QvmmeMrJ0=";
  };

  buildInputs = [
    gtk2
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Application launcher written in C and using GTK for the interface";
    mainProgram = "grun";
    homepage = "https://github.com/lrgc/grun";
    platforms = platforms.linux;
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
  };
}
