{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  makeWrapper,
  autoPatchelfHook,
  wrapGAppsHook3,
  gtk3,
  glib,
  libsecret,
  libx11,
  libxtst,
  openjdk11,
  webkitgtk_4_1,
  glib-networking,
}:

let
  # SWT 3.120 hardcodes dlopen("libwebkit2gtk-4.0.so.37") but nixpkgs
  # only ships webkitgtk_4_1 (soname libwebkit2gtk-4.1.so.0).
  webkitCompat = stdenvNoCC.mkDerivation {
    name = "webkitgtk-4.0-compat";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/lib
      ln -s ${webkitgtk_4_1}/lib/libwebkit2gtk-4.1.so.0 $out/lib/libwebkit2gtk-4.0.so.37
    '';
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "modelio";
  version = "5.4.1";

  src = fetchurl {
    url = "https://github.com/ModelioOpenSource/Modelio/releases/download/v${finalAttrs.version}/modelio-open-source-${finalAttrs.version}_amd64.deb";
    hash = "sha256-cg7ruIYpOgz2nfax37M8sUs89Qvbb5PMudyR0ZNiURo=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    glib
    libsecret
    libx11
    libxtst
  ];

  strictDeps = true;
  __structuredAttrs = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --extract $src .
    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    rm -rf usr/lib/modelio-open-source5.4/jre

    mkdir -p $out/opt/modelio $out/bin
    cp -r usr/lib/modelio-open-source5.4/* $out/opt/modelio

    # Remove upstream's blanket TLS error suppression
    substituteInPlace $out/opt/modelio/modelio.ini \
      --replace-fail "-Dorg.eclipse.swt.internal.webkitgtk.ignoretlserrors=true" ""

    # change dark theme to light theme as the text isn't readable in dark themes GTK_THEME "Adwaita:light" isn't enough
    # https://github.com/ModelioOpenSource/Modelio/issues/59
    cp $out/opt/modelio/plugins/org.eclipse.ui.themes_1.2.1200.v20201112-1139/css/{e4_basestyle,e4-dark_linux}.css

    # --set GTK_THEME "Adwaita:light" as the text isn't readable in dark themes
    # https://github.com/ModelioOpenSource/Modelio/issues/59
    makeWrapper $out/opt/modelio/modelio $out/bin/modelio \
      --prefix PATH : "${openjdk11}/bin" \
      --set JAVA_HOME "${openjdk11.home}" \
      --set GDK_BACKEND "x11" \
      --set GTK_THEME "Adwaita:light" \
      --set SWT_GTK3 "1" \
      --set SWT_WEBKIT2 "1" \
      --set UBUNTU_MENUPROXY "0" \
      --set LIBOVERLAY_SCROLLBAR "0" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          gtk3
          glib
          webkitCompat
          glib-networking
        ]
      }"

    mkdir -p $out/share/applications
    cp usr/share/applications/modelio-open-source5.4.desktop $out/share/applications/modelio.desktop
    substituteInPlace $out/share/applications/modelio.desktop \
      --replace-fail "Exec=/usr/bin/modelio-open-source5.4" "Exec=$out/bin/modelio" \
      --replace-fail "Icon=modelio-open-source5.4" "Icon=modelio"

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp usr/share/icons/hicolor/scalable/apps/modelio-open-source5.4.svg \
       $out/share/icons/hicolor/scalable/apps/modelio.svg

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.modelio.org/";
    changelog = "https://github.com/ModelioOpenSource/Modelio/releases/tag/v${finalAttrs.version}";
    description = "Open-source UML, BPMN, ArchiMate and SysML modeling environment";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ gamebeaker ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "modelio";
  };
})
