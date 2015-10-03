{ stdenv, lib, fetchgit, pkgconfig, zathura_core, gtk, girara, mupdf, openssl, openjpeg, libjpeg, jbig2dec }:

stdenv.mkDerivation rec {
  version = "0.2.7";
  name = "zathura-pdf-mupdf-${version}";

  src = fetchgit {
    url = "https://git.pwmt.org/zathura-pdf-mupdf.git";
    rev = "99bff723291f5aa2558e5c8b475f496025105f4a";
    sha256 = "14mfp116a8dmazss3dcipvjs6dclazp36vsbcc53lr8lal5ccfnf";
  };

  buildInputs = [ pkgconfig zathura_core gtk girara openssl mupdf openjpeg libjpeg jbig2dec ];

  makeFlags = "PREFIX=$(out) PLUGINDIR=$(out)/lib";

  patches = [
    ./config.patch
  ];

  meta = with lib; {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A zathura PDF plugin (mupdf)";
    longDescription = ''
      The zathura-pdf-mupdf plugin adds PDF support to zathura by
      using the mupdf rendering library.
    '';
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
