{
  lib,
  stdenv,
  fetchFromGitHub,
  imagemagick,
  gettext,
  pidgin,
  json-glib,
}:

stdenv.mkDerivation {
  pname = "purple-discord";
  version = "unstable-2021-10-17";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "purple-discord";
    rev = "b7ac72399218d2ce011ac84bb171b572560aa2d2";
    hash = "sha256-JKChlhZMn85xRyn7QFMyD7J8gAekpqlLyWzrt1tOcnc=";
  };

  nativeBuildInputs = [
    imagemagick
    gettext
  ];
  buildInputs = [
    pidgin
    json-glib
  ];

  env = {
    PKG_CONFIG_PURPLE_PLUGINDIR = "${placeholder "out"}/lib/purple-2";
    PKG_CONFIG_PURPLE_DATADIR = "${placeholder "out"}/share";
  };

  meta = {
    homepage = "https://github.com/EionRobb/purple-discord";
    description = "Discord plugin for Pidgin";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sna ];
  };
}
