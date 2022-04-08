{ lib
, stdenv
, fetchFromGitHub
, gumbo
, harfbuzz
, jbig2dec
, mupdf
, openjpeg
, qt3d
, qtbase
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "sioyek";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ahrm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UhZuELWfFfqj1jjCgZTD+X44i7jMpeDTbClkZarV2Zw=";
  };

  buildInputs = [ gumbo harfbuzz jbig2dec mupdf openjpeg qt3d qtbase ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  buildPhase = ''
    # Remove nonexistent lib and insert missing ones
    sed -i 's/-lmupdf-threads/-lfreetype -lgumbo -ljbig2dec -lopenjp2 -ljpeg/' pdf_viewer_build_config.pro
    qmake pdf_viewer_build_config.pro
    make
  '';

  installPhase = ''
    install -Dm755 sioyek $out/bin/sioyek
    install -Dm644 tutorial.pdf $out/bin/tutorial.pdf
    install -Dm644 -t $out/bin/ pdf_viewer/{keys,prefs}.config
    cp -r pdf_viewer/shaders $out/bin/
  '';

  postInstall = ''
    install -Dm644 resource/sioyek-icon-linux.png $out/usr/share/icons/sioyek-icon-linux.png
    install -Dm644 resource/sioyek.desktop $out/usr/share/applications/sioyek.desktop
    installManPage resources/sioyek.1
  '';

  meta = with lib; {
    description = "Sioyek is a PDF viewer designed for reading research papers and technical books.";
    homepage = "https://sioyek.info/";
    changelog = "https://github.com/ahrm/sioyek/releases";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.podocarp ];
  };
}
