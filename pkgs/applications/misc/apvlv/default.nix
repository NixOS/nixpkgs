{ stdenv, fetchurl, cmake, pkgconfig,
  gtk2 , poppler, freetype, libpthreadstubs, libXdmcp, libxshmfence
}:

stdenv.mkDerivation rec {
  version = "0.1.f7f7b9c";
  name = "apvlv-${version}";

  src = fetchurl {
    url = "https://github.com/downloads/naihe2010/apvlv/${name}-Source.tar.gz";
    sha256 = "125nlcfjdhgzi9jjxh9l2yc9g39l6jahf8qh2555q20xkxf4rl0w";
  };

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${poppler.dev}/include/poppler"
  '';

  buildInputs = [
    pkgconfig cmake
     poppler
     freetype gtk2
     libpthreadstubs libXdmcp libxshmfence # otherwise warnings in compilation
   ];

  installPhase = ''
    # binary
    mkdir -p $out/bin
    cp src/apvlv $out/bin/apvlv

    # displays pdfStartup.pdf as default pdf entry
    mkdir -p $out/share/doc/apvlv/
    cp ../Startup.pdf $out/share/doc/apvlv/Startup.pdf
  '';

  meta = with stdenv.lib; {
    homepage = "http://naihe2010.github.io/apvlv/";
    description = "PDF viewer with Vim-like behaviour";
    longDescription = ''
      apvlv is a PDF/DJVU/UMD/TXT Viewer Under Linux/WIN32
      with Vim-like behaviour.
    '';

    license = licenses.lgpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.ardumont ];
  };

}
