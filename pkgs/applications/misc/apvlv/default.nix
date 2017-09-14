{ stdenv, fetchFromGitHub, fetchpatch, cmake, pkgconfig, pcre, libxkbcommon, epoxy
, gtk3, poppler, freetype, libpthreadstubs, libXdmcp, libxshmfence, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "0.1.5";
  name = "apvlv-${version}";

  src = fetchFromGitHub {
    owner = "naihe2010";
    repo = "apvlv";
    rev = "v${version}";
    sha256 = "1n4xiic8lqnv3mqi7wpdv866gyyakax71gffv3n9427rmcld465i";
  };

  NIX_CFLAGS_COMPILE = "-I${poppler.dev}/include/poppler";

  buildInputs = [
    pkgconfig cmake
    poppler pcre libxkbcommon epoxy
    freetype gtk3
    libpthreadstubs libXdmcp libxshmfence # otherwise warnings in compilation
  ];

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/naihe2010/apvlv/commit/d432635b9c5ea6c052a2ae1fb71aedec5c4ad57a.patch";
      sha256 = "1am8dgv2kkpqmm2vaysa61czx8ppdx94zb3c59sx88np50jpy70w";
    })
    (fetchpatch {
      url = "https://github.com/naihe2010/apvlv/commit/4c7a583e8431964def482e5471f02e6de8e62a7b.patch";
      sha256 = "1dszm120lwm90hcg5zmd4vr6pjyaxc84qmb7k0fr59mmb3qif62j";
    })
  ];

  installPhase = ''
    # binary
    mkdir -p $out/bin
    cp src/apvlv $out/bin/apvlv

    # displays pdfStartup.pdf as default pdf entry
    mkdir -p $out/share/doc/apvlv/
    cp ../Startup.pdf $out/share/doc/apvlv/Startup.pdf
    cp ../main_menubar.glade $out/share/doc/apvlv/main_menubar.glade
  '';

  meta = with stdenv.lib; {
    homepage = http://naihe2010.github.io/apvlv/;
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
