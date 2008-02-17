args: with args;
stdenv.mkDerivation (rec {
  pname = "rxvt-unicode";
  version = "9.02";

  name = "${pname}-${version}";

 src = fetchurl {
    url = "http://dist.schmorp.de/rxvt-unicode/Attic/${name}.tar.bz2";
    sha256 = "234b9a3e3f88c4984b1e909f8028638fc3b61d801d8afaa9cd08154b1a480a31";
  };

  buildInputs = [ libX11 libXt libXft ];
  configureFlags = "--disable-perl";

  meta = {
    description = "rxvt-unicode is a clone of the well known terminal emulator rxvt.";
    homepage = "http://software.schmorp.de/pkg/rxvt-unicode.html";
  };
})
