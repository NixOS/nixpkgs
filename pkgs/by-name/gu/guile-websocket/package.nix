{
  lib
, stdenv
, fetchurl
, guile
, guile-gnutls
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "guile-websocket";
  version = "0.2.0";

  src = fetchurl {
    url = "https://files.dthompson.us/guile-websocket/guile-websocket-${version}.tar.gz";
    hash = "sha256-7jxj+I5WpqtGu99zrzl92eIZUThy69A4CsLzXnp4dpA=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    guile-gnutls
    guile
  ];

  makeFlags = [
    "GUILE_AUTO_COMPILE=0"
  ];

  meta = {
    homepage = "https://dthompson.us/projects/guile-websocket.html";
    description = "An implementation of the WebSocket protocol for Guile";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      jboy
    ];
    platforms = lib.platforms.all;
  };
}
