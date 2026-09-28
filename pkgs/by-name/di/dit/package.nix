{
  lib,
  fetchurl,
  stdenv,
  libiconv,
  ncurses,
  lua,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dit";
  version = "0.9";

  src = fetchurl {
    url = "https://hisham.hm/dit/releases/${finalAttrs.version}/dit-${finalAttrs.version}.tar.gz";
    hash = "sha256-p1uD0Q2kqB40fbAEk7/fdOVg9T7SW+2aACSn7hDAD+E=";
  };

  buildInputs = [
    ncurses
    lua
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  # fix paths
  prePatch = ''
    patchShebangs tools/GenHeaders
    substituteInPlace Prototypes.h --replace 'tail' "$(type -P tail)"
  '';

  meta = {
    description = "Console text editor for Unix that you already know how to use";
    homepage = "https://hisham.hm/dit/";
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [ davidak ];
    mainProgram = "dit";
  };
})
