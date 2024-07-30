{
  cmake,
  copyDesktopItems,
  ebook_tools,
  fetchFromGitHub,
  freetype,
  ghostscript,
  gtk3,
  installShellFiles,
  lib,
  libepoxy,
  libpthreadstubs,
  libXdmcp,
  libxkbcommon,
  libxml2,
  libxshmfence,
  man,
  pcre,
  pkg-config,
  poppler,
  stdenv,
  testers,
  webkitgtk,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apvlv";

  # If you change the version, please also update src.rev accordingly
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "naihe2010";
    repo = "apvlv";
    rev = "refs/tags/v0.5.0-final";
    hash = "sha256-5Wbv3dXieymhhPmEKQu8X/38WsDA1T/IBPoMXdpzcaA=";
  };

  env.NIX_CFLAGS_COMPILE = "-I${poppler.dev}/include/poppler";

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ghostscript
    installShellFiles
    man
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    ebook_tools
    freetype
    gtk3
    libepoxy
    libpthreadstubs
    libXdmcp
    libxkbcommon
    libxml2
    libxshmfence # otherwise warnings in compilation
    pcre
    poppler
    webkitgtk
  ];

  installPhase = ''
    runHook preInstall

    # binary
    mkdir -p $out/bin
    cp src/apvlv $out/bin/apvlv

    # displays pdfStartup.pdf as default pdf entry
    mkdir -p $out/share/doc/apvlv/
    cp ../Startup.pdf $out/share/doc/apvlv/Startup.pdf
    cp ../main_menubar.glade $out/share/doc/apvlv/main_menubar.glade

    mkdir -p $out/etc
    cp ../apvlvrc.example $out/etc/apvlvrc

    installManPage ../apvlv.1

    runHook postInstall
  '';

  desktopItems = [
    "../apvlv.desktop"
  ];

  passthru = {
    tests.version = testers.testVersion {
      command = "${lib.getExe finalAttrs.finalPackage} -v";
      package = finalAttrs.finalPackage;
      version = "${finalAttrs.version}-rel";
    };
  };

  meta = {
    changelog = "https://github.com/naihe2010/apvlv/blob/v${finalAttrs.version}/NEWS";
    description = "PDF viewer with Vim-like behaviour";
    homepage = "https://naihe2010.github.io/apvlv/";
    license = lib.licenses.lgpl2;
    longDescription = ''
      apvlv is a PDF/DJVU/UMD/TXT Viewer Under Linux/WIN32
      with Vim-like behaviour.
    '';
    mainProgram = "apvlv";
    maintainers = with lib.maintainers; [ ardumont anthonyroussel ];
    platforms = lib.platforms.linux;
  };
})
