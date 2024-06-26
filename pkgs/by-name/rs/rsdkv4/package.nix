{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, glew
, SDL2
, libvorbis
, libXcursor
, libXrandr
, libXext
, libXScrnSaver
, libXi
, libXfixes
}:

stdenv.mkDerivation rec {
  pname = "RSDKv4";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "Rubberduckycooly";
    repo = "Sonic-1-2-2013-Decompilation";
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-hTBhSfauu0ccEtu/chyIr7EAXjlgYiZpeU66AkgreUo=";
  };

  postPatch = ''
    substituteInPlace RSDKv4/RetroEngine.hpp \
      --replace-fail '#include <SDL.h>' '#include <SDL2/SDL.h>'
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glew SDL2 libvorbis libXcursor libXext libXScrnSaver libXrandr libXi libXfixes ];

  makeFlags = [ "RETRO_DISABLE_PLUS=1" ];
  installFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Decompilation of Sonic 1 & Sonic 2";
    homepage = "https://github.com/Rubberduckycooly/Sonic-1-2-2013-Decompilation";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ lib.maintainers.puffnfresh ];
    platforms = lib.platforms.linux;
  };
}
