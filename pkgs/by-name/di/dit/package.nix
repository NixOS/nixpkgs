{
  lib,
  fetchurl,
  stdenv,
  libiconv,
  ncurses,
  lua,
}:

stdenv.mkDerivation rec {
  pname = "dit";
  version = "0.9";

  src = fetchurl {
    url = "https://hisham.hm/dit/releases/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-p1uD0Q2kqB40fbAEk7/fdOVg9T7SW+2aACSn7hDAD+E=";
  };

  buildInputs = [
    ncurses
    lua
  ] ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  # fix paths
  prePatch = ''
    patchShebangs tools/GenHeaders
    substituteInPlace Prototypes.h --replace 'tail' "$(type -P tail)"
  '';

  meta = with lib; {
    description = "Console text editor for Unix that you already know how to use";
    homepage = "https://hisham.hm/dit/";
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ davidak ];
    mainProgram = "dit";
  };
}
