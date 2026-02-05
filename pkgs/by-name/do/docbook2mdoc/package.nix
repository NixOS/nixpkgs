{
  lib,
  stdenv,
  fetchurl,
  expat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "docbook2mdoc";
  version = "0.0.9";

  src = fetchurl {
    url = "http://mdocml.bsd.lv/docbook2mdoc/snapshots/docbook2mdoc-${finalAttrs.version}.tgz";
    sha256 = "07il80sg89xf6ym4bry6hxdacfzqgbwkxzyf7bjaihmw5jj0lclk";
  };

  buildInputs = [ expat.dev ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "http://mdocml.bsd.lv/";
    description = "Converter from DocBook V4.x and v5.x XML into mdoc";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ramkromberg ];
    mainProgram = "docbook2mdoc";
  };
})
