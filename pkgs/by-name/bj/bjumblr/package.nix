{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  cairo,
  lv2,
  pkg-config,
  libsndfile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bjumblr";
  version = "1.6.8";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = "BJumblr";
    tag = finalAttrs.version;
    sha256 = "sha256-qSoGmWUGaMjx/bkiCJ/qb4LBbuFPXXlJ0e9hrFBXzwE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libX11
    cairo
    lv2
    libsndfile
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/sjaehn/BJumblr";
    description = "Pattern-controlled audio stream / sample re-sequencer LV2 plugin";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
  };
})
