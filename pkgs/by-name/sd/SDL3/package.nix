{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL3";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL";
    rev = "preview-${finalAttrs.version}";
    hash = "sha256-S7yRcLHMPgq6+gec8l+ESxp2dJ+6Po/UNsBUXptQzMQ=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Cross-platform multimedia library";
    homepage = "http://www.libsdl.org/";
    changelog = "https://github.com/libsdl-org/SDL/releases/tag/preview-${finalAttrs.version}";
    license = licenses.zlib;
    platforms = platforms.all;
    maintainers = lib.teams.sdl.members;
  };
})
