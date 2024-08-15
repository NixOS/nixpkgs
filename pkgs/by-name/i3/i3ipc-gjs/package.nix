{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, gjs
, i3ipc-glib
, pkg-config
, which
}:
stdenv.mkDerivation rec {
  pname = "i3ipc-gjs";
  version = "0.1.2";

  meta = with lib; {
    description = "An improved JavaScript library to control i3wm";
    homepage = "https://github.com/acrisci/i3ipc-gjs";
    maintainers = with maintainers; [tesnos6921];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };

  nativeBuildInputs = [
    autoreconfHook
    gjs
    pkg-config
    which
  ];

  buildInputs = [
    gjs
    i3ipc-glib
  ];

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "i3ipc-gjs";
    rev = "v${version}";
    sha256 = "sha256-x5XMS3md3V2ytBgtQ6pXRynNF6PqL+GjQwPJYUl54UY=";
  };

  configureFlags = [
    (lib.withFeatureAs true "gjs-overrides-dir" "$(out)/usr/share/gjs-1.0/overrides")
  ];
}
