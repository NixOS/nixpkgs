{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  cppunit,
  dbus,
  directoryListingUpdater,
  fzssh,
  gettext,
  gnutls,
  libfilezilla,
  libidn,
  makeBinaryWrapper,
  nettle,
  pkg-config,
  pugixml,
  sqlite,
  tinyxml,
  boost,
  wrapGAppsHook3,
  wxwidgets_3_2,
  gtk3,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "filezilla";
  version = "3.71.1";
  __structuredAttrs = true;

  src = fetchurl {
    # Upstream download link was made unstable on purpose
    # See https://trac.filezilla-project.org/ticket/13186
    url = "https://sources.archlinux.org/other/filezilla/filezilla-${finalAttrs.version}.tar.xz";
    hash = "sha256-Pfm5s+Wyw33G2ey4g1VKuhQKAuxHw9a1IzO/FzOvTaQ=";
  };

  # The engine library uses pugixml but doesn't link it, which only works
  # where the linker allows undefined symbols in shared libraries
  postPatch = ''
    substituteInPlace src/engine/Makefile.am \
      --replace-fail '$(LIBFZSSH_LIBS) $(LIBFILEZILLA_LIBS)' '$(LIBFZSSH_LIBS) $(LIBFILEZILLA_LIBS) $(PUGIXML_LIBS)'
  '';

  configureFlags = [
    "--disable-manualupdatecheck"
    "--disable-autoupdatecheck"
    "--with-wx-prefix=${wxwidgets_3_2}"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
    xdg-utils
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
  ];

  buildInputs = [
    boost
    fzssh
    gettext
    gnutls
    libfilezilla
    libidn
    nettle
    pugixml
    sqlite
    tinyxml
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    gtk3
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  doCheck = true;

  checkInputs = [ cppunit ];

  # On macOS, FileZilla only looks for its resources inside the app bundle.
  # Upstream's bundle carries copies of all dylibs in Frameworks, which our
  # installed binary doesn't use.
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r FileZilla.app $out/Applications/
    rm -r $out/Applications/FileZilla.app/Contents/Frameworks
    mv $out/bin/filezilla $out/Applications/FileZilla.app/Contents/MacOS/filezilla
    makeWrapper $out/Applications/FileZilla.app/Contents/MacOS/filezilla $out/bin/filezilla
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}"
    )
  '';

  passthru.updateScript = directoryListingUpdater { };

  meta = {
    homepage = "https://filezilla-project.org/";
    description = "Graphical FTP, FTPS and SFTP client";
    longDescription = ''
      FileZilla Client is a free, open source FTP client. It supports
      FTP, SFTP, and FTPS (FTP over SSL/TLS). The client is available
      under many platforms, binaries for Windows, Linux and macOS are
      provided.
    '';
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      iedame
      pSub
    ];
  };
})
