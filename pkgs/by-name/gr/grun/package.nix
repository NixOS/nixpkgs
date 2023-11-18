{ lib
, stdenv
, fetchFromGitHub
, gtk2
, pkg-config
, autoreconfHook
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

  meta = {
    description = "An application launcher written in C and using GTK for the interface";
    homepage = "https://github.com/lrgc/grun";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
  };
}

