{
  lib,
  stdenv,
  installShellFiles,
  fetchFromGitHub,
  fetchurl,
  freetype,
  gumbo,
  harfbuzz,
  jbig2dec,
  mujs,
  mupdf,
  openjpeg,
  qt3d,
  qtbase,
  qmake,
  wrapQtAppsHook,
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

  patches = [
    # Fixed compatibility with mupdf-0.23.0
    # https://github.com/ahrm/sioyek/issues/804
    (fetchurl {
      url = "https://git.alpinelinux.org/aports/plain/community/sioyek/mupdf-0.23.0.patch?id=86e913eccf19b97a16f25d9b6cdf0f50232f1226";
      hash = "sha256-sEqhpk7/h6g/fIhbu5LgpKKnbnIFLInrTP1k+/GhrXE=";
    })
  ];

  buildInputs = [
    gumbo
    harfbuzz
    jbig2dec
    mujs
    mupdf
    openjpeg
    qt3d
    qtbase
  ] ++ lib.optionals stdenv.isDarwin [ freetype ];

  nativeBuildInputs = [
    installShellFiles
    qmake
    wrapQtAppsHook
  ];

  qmakeFlags = lib.optionals stdenv.isDarwin [ "CONFIG+=non_portable" ];

  postPatch = ''
    substituteInPlace pdf_viewer_build_config.pro \
      --replace "-lmupdf-threads" "-lgumbo -lharfbuzz -lfreetype -ljbig2dec -ljpeg -lopenjp2" \
      --replace "-lmupdf-third" ""
    substituteInPlace pdf_viewer/main.cpp \
      --replace "/usr/share/sioyek" "$out/share" \
      --replace "/etc/sioyek" "$out/etc"
  '';

  postInstall =
    if stdenv.isDarwin then
      ''
        cp -r pdf_viewer/shaders sioyek.app/Contents/MacOS/shaders
        cp pdf_viewer/prefs.config sioyek.app/Contents/MacOS/
        cp pdf_viewer/prefs_user.config sioyek.app/Contents/MacOS/
        cp pdf_viewer/keys.config sioyek.app/Contents/MacOS/
        cp pdf_viewer/keys_user.config sioyek.app/Contents/MacOS/
        cp tutorial.pdf sioyek.app/Contents/MacOS/

        mkdir -p $out/Applications $out/bin
        cp -r sioyek.app $out/Applications
        ln -s $out/Applications/sioyek.app/Contents/MacOS/sioyek $out/bin/sioyek
      ''
    else
      ''
        install -Dm644 tutorial.pdf $out/share/tutorial.pdf
        cp -r pdf_viewer/shaders $out/share/
        install -Dm644 -t $out/etc/ pdf_viewer/{keys,prefs}.config
        installManPage resources/sioyek.1
      '';

  meta = with lib; {
    homepage = "https://sioyek.info/";
    description = "PDF viewer designed for research papers and technical books";
    mainProgram = "sioyek";
    changelog = "https://github.com/ahrm/sioyek/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ podocarp ];
    platforms = platforms.unix;
  };
})
