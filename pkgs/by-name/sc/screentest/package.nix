{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, intltool
, pkg-config
, gtk2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "screentest";
  version = "unstable-2021-05-10";

  src = fetchFromGitHub {
    owner = "TobiX";
    repo = "screentest";
    rev = "780e6cbbbbd6ba93e246e7747fe593b40c4e2747";
    hash = "sha256-TJ47c77vQ/aRBJ2uEiFLuAR4dd4CMEo+iAAx0HCFbmA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
    gtk2 # for autoconf macros
  ];

  buildInputs = [
    gtk2
  ];

  meta = with lib; {
    description = "A simple screen testing tool";
    homepage = "https://github.com/TobiX/screentest";
    changelog = "https://github.com/TobiX/screentest/blob/${finalAttrs.src.rev}/NEWS";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ evils ];
    platforms = platforms.unix;
  };
})
