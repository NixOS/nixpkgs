{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libpng
}:

stdenv.mkDerivation rec {
  pname = "deutex";
  version = "5.2.3";

  src = fetchFromGitHub {
    owner = "Doom-Utils";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-wDAlwOtupkYv6y4fQPwL/PVOhh7wqORnjxV22kmON+U=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libpng
  ];


  installPhase = ''
    mkdir -p $out/bin
    cp -r src/deutex $out/bin
  '';

  meta = {
    homepage = "https://github.com/Doom-Utils/deutex/";
    description = "WAD composer for Doom, Heretic, Hexen, and Strife";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
}
