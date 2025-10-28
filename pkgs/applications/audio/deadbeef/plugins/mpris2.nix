{
  lib,
  stdenv,
  fetchFromGitHub,
  deadbeef,
  autoreconfHook,
  pkg-config,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deadbeef-mpris2-plugin";
  version = "1.16";

  src = fetchFromGitHub {
    owner = "DeaDBeeF-Player";
    repo = "deadbeef-mpris2-plugin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-f6iHgwLdzQJJEquyuUQGWFfOfpjH/Hxh9IqQ5HkYrog=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    deadbeef
    glib
  ];

  meta = with lib; {
    description = "MPRISv2 plugin for the DeaDBeeF music player";
    homepage = "https://github.com/DeaDBeeF-Player/deadbeef-mpris2-plugin/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ ];
  };
})
