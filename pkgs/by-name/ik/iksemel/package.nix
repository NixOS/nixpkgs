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
    hash = "sha256-0KdvwnCzAZ69ZIW7N1kaM2bYOTd/6MdwvxYSMq4AY/c=";
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
