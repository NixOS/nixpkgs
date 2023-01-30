{ lib
, stdenv
, installShellFiles
, fetchFromGitHub
, freetype
, gumbo
, harfbuzz
, jbig2dec
, mujs
, mupdf
, openjpeg
, qt3d
, qtbase
, qmake
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sioyek";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "ahrm";
    repo = "sioyek";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-GFZaTXJhoBB+rSe7Qk6H6FZJVXr3nO9XgM+LAbS4te4=";
  };

  buildInputs = [
    gumbo
    harfbuzz
    jbig2dec
    mujs
    mupdf
    openjpeg
    qt3d
    qtbase
  ]
  ++ lib.optionals stdenv.isDarwin [ freetype ];

  nativeBuildInputs = [
    installShellFiles
    qmake
    wrapQtAppsHook
  ];

  qmakeFlags = lib.optionals stdenv.isDarwin [ "CONFIG+=non_portable" ];

  postPatch = ''
    substituteInPlace pdf_viewer_build_config.pro \
      --replace "-lmupdf-threads" "-lgumbo -lharfbuzz -lfreetype -ljbig2dec -ljpeg -lopenjp2"
    substituteInPlace pdf_viewer/main.cpp \
      --replace "/usr/share/sioyek" "$out/share" \
      --replace "/etc/sioyek" "$out/etc"
  '';

  postInstall = if stdenv.isDarwin then ''
    cp -r pdf_viewer/shaders sioyek.app/Contents/MacOS/shaders
    cp pdf_viewer/prefs.config sioyek.app/Contents/MacOS/
    cp pdf_viewer/prefs_user.config sioyek.app/Contents/MacOS/
    cp pdf_viewer/keys.config sioyek.app/Contents/MacOS/
    cp pdf_viewer/keys_user.config sioyek.app/Contents/MacOS/
    cp tutorial.pdf sioyek.app/Contents/MacOS/

    mkdir -p $out/Applications
    cp -r sioyek.app $out/Applications
  '' else ''
    install -Dm644 tutorial.pdf $out/share/tutorial.pdf
    cp -r pdf_viewer/shaders $out/share/
    install -Dm644 -t $out/etc/ pdf_viewer/{keys,prefs}.config
    installManPage resources/sioyek.1
  '';

  meta = with lib; {
    homepage = "https://sioyek.info/";
    description = "A PDF viewer designed for research papers and technical books";
    changelog = "https://github.com/ahrm/sioyek/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ podocarp ];
    platforms = platforms.unix;
  };
})
