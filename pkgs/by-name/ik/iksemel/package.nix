{
  lib,
  stdenv,
  autoreconfHook,
  libtool,
  pkg-config,
  gnutls,
  fetchFromGitHub,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iksemel";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "timothytylee";
    repo = "iksemel-1.4";
    rev = "v${finalAttrs.version}";
    sha256 = "1xv302p344hnpxqcgs3z6wwxhrik39ckgfw5cjyrw0dkf316z9yh";
  };

  patches = [
    ./update-texinfo.diff
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    libtool
    texinfo
  ];
  buildInputs = [ gnutls ];

  meta = {
    description = "XML parser for jabber";

    homepage = "https://github.com/timothytylee/iksemel-1.4";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
