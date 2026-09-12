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
  version = "2.0.0-unstable-2026-08-18";

  src = fetchFromGitHub {
    owner = "ahrm";
    repo = "sioyek";
    rev = "d0b2c1915ececf8394c355b9e4dcdd675154f5d0";
    hash = "sha256-Mun68PZXpSuU8xzo0wmBbQgGwGoLPkfDhgz6dKxeIDI=";
  };

  buildInputs = [
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

  meta = {
    homepage = "https://sioyek.info/";
    description = "PDF viewer designed for research papers and technical books";
    mainProgram = "sioyek";
    # no changelog for unstable version, change back to
    # https://github.com/ahrm/sioyek/releases/tag/v${finalAttrs.version}
    # once stable again
    changelog = "https://github.com/ahrm/sioyek/releases";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      podocarp
      stephen-huan
      xyven1
      stephsi
    ];
    platforms = lib.platforms.unix;
  };
})
