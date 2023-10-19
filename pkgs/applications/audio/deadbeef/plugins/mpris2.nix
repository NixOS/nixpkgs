{ lib
, stdenv
, fetchFromGitHub
, deadbeef
, autoreconfHook
, pkg-config
, glib
}:

let
  pname = "deadbeef-mpris2-plugin";
  version = "1.16";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "DeaDBeeF-Player";
    repo = pname;
    rev = "v${version}";
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
    maintainers = [ maintainers.abbradar ];
  };
}
