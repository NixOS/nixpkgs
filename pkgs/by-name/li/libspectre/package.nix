{
  fetchurl,
  lib,
  stdenv,
  pkg-config,
  ghostscript,
  cairo,
}:

stdenv.mkDerivation rec {
  pname = "libspectre";
  version = "0.2.12";

  src = fetchurl {
    url = "https://libspectre.freedesktop.org/releases/${pname}-${version}.tar.gz";
    hash = "sha256-VadRfNNXK9JWXfDPRQlEoE1Sc7J567NpqJU5GVfw+WA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    # Need `libgs.so'.
    ghostscript
  ];

  doCheck = true;

  checkInputs = [
    cairo
  ];

  meta = {
    homepage = "http://libspectre.freedesktop.org/";
    description = "PostScript rendering library";

    longDescription = ''
      libspectre is a small library for rendering Postscript
      documents.  It provides a convenient easy to use API for
      handling and rendering Postscript documents.
    '';

    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
