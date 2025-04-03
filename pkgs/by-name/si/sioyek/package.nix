{
  lib,
  stdenv,
  installShellFiles,
  fetchFromGitHub,
  freetype,
  unstableGitUpdater,
  gumbo,
  harfbuzz,
  jbig2dec,
  mujs,
  mupdf,
  openjpeg,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sioyek";
  version = "2.0.0-unstable-2025-03-11";

  src = fetchFromGitHub {
    owner = "ahrm";
    repo = "sioyek";
    rev = "b3575d9634d6c305cdf555a383e019a1e9013f2a";
    hash = "sha256-a6zIgFe8bHrqXAtCC4/LC5jl3hy2Cs1xZBI91sKQgqw=";
  };

  buildInputs =
    [
      gumbo
      harfbuzz
      jbig2dec
      mujs
      mupdf
      openjpeg
      qt6.qt3d
      qt6.qtbase
      qt6.qtspeech
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ qt6.qtwayland ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ freetype ];

  nativeBuildInputs = [
    installShellFiles
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  qmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "CONFIG+=non_portable" ];

  postPatch = ''
    substituteInPlace pdf_viewer_build_config.pro \
      --replace-fail "-lmupdf-threads" "-lgumbo -lharfbuzz -lfreetype -ljbig2dec -ljpeg -lopenjp2" \
      --replace-fail "-lmupdf-third" ""
    substituteInPlace pdf_viewer/main.cpp \
      --replace-fail "/usr/share/sioyek" "$out/share" \
      --replace-fail "/etc/sioyek" "$out/etc"
  '';

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        cp -r pdf_viewer/shaders sioyek.app/Contents/MacOS/shaders
        cp pdf_viewer/{prefs,prefs_user,keys,keys_user}.config tutorial.pdf sioyek.app/Contents/MacOS/

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

  passthru.updateScript = unstableGitUpdater {
    branch = "development";
    tagPrefix = "v";
  };

  meta = with lib; {
    homepage = "https://sioyek.info/";
    description = "PDF viewer designed for research papers and technical books";
    mainProgram = "sioyek";
    changelog = "https://github.com/ahrm/sioyek/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      podocarp
      stephen-huan
      xyven1
    ];
    platforms = platforms.unix;
  };
})
