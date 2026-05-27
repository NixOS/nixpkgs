{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  unzip,
  gtk3,
  glib,
  atk,
  gdk-pixbuf,
  cairo,
  pango,
  openjdk11,
  freetype,
  fontconfig,
  libnotify,
  cups,
  alsa-lib,
  nspr,
  nss,
  libsecret,
  libGLU,
  libGL,
  webkitgtk_4_1,
  glib-networking,
  libx11,
  libxext,
  libxrender,
  libxi,
  libxtst,
  libxxf86vm,
  libxcursor,
  libxfixes,
  libxcomposite,
  libxdamage,
  libxrandr,
  libxkbfile,
  lcms2,
}:

let
  modelioVersion = "5.4";
  swtJar = "org.eclipse.swt.gtk.linux.x86_64_3.120.0.v20220530-1036.jar";

  # SWT 3.120 hardcodes dlopen("libwebkit2gtk-4.0.so.37") but nixpkgs
  # only ships webkitgtk_4_1 (soname libwebkit2gtk-4.1.so.0).
  # The 4.0->4.1 change was solely a libsoup2->libsoup3 switch; the
  # webkit2gtk C API and ABI are otherwise identical.
  webkitCompat = stdenvNoCC.mkDerivation {
    name = "webkitgtk-4.0-compat";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/lib
      ln -s ${lib.getLib webkitgtk_4_1}/lib/libwebkit2gtk-4.1.so.0 $out/lib/libwebkit2gtk-4.0.so.37
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
    autoPatchelfHook
    makeWrapper
    unzip
  ];

  buildInputs = [
    gtk3
    glib
    atk
    gdk-pixbuf
    cairo
    pango
    freetype
    fontconfig
    libnotify
    cups
    alsa-lib
    nspr
    nss
    libsecret
    libGLU
    libGL
    webkitgtk_4_1
    openjdk11
    lcms2
    libx11
    libxext
    libxrender
    libxi
    libxtst
    libxxf86vm
    libxcursor
    libxfixes
    libxcomposite
    libxdamage
    libxrandr
    libxkbfile
  ];

  strictDeps = true;
  __structuredAttrs = true;

  dontWrapPrograms = true;
  dontBuild = true;
  sourceRoot = ".";

  unpackPhase = ''
    mkdir -p extracted
    cd extracted
    ar x "$src"
    tar xf data.tar.xz
    cd ..
  '';

  installPhase = ''
        runHook preInstall

        mkdir -p "$out/lib"
        cp -r extracted/usr/lib/modelio-open-source${modelioVersion}/* "$out/lib/"
        mkdir -p "$out/share"
        if [ -d extracted/usr/share ]; then
          cp -r extracted/usr/share/* "$out/share/"
        fi

        # Use nixpkgs OpenJDK instead of bundled one
        rm -rf "$out/lib/jre"

        cat > "$out/lib/modelio.config" <<'CONFIG_EOF'
    MODELIO_PATH=@out@/lib
    SWT_GTK3=1
    SWT_WEBKIT2=1
    UBUNTU_MENUPROXY=0
    LIBOVERLAY_SCROLLBAR=0
    CONFIG_EOF
        substituteInPlace "$out/lib/modelio.config" --replace "@out@" "$out"

        runHook postInstall
  '';

  postFixup = ''
    # Pre-extract SWT native libraries from the SWT GTK jar
    mkdir -p "$out/lib/swt-native"
    unzip -o "$out/lib/plugins/${swtJar}" "*.so" -d "$out/lib/swt-native/" 2>/dev/null || true
    rm -f "$out/lib/swt-native/libswt-awt"*
    # Create symlinks for all possible SWT library name variants
    for lib in "$out/lib/swt-native/"*.so; do
      base=$(basename "$lib")
      simple=$(echo "$base" | sed 's/-[0-9]*r[0-9]*\.so$/.so/')
      if [ "$simple" != "$base" ] && [ ! -f "$out/lib/swt-native/$simple" ]; then
        ln -sf "$base" "$out/lib/swt-native/$simple"
      fi
      base_only=$(echo "$base" | sed 's/-gtk-[0-9]*r[0-9]*\.so$/.so/')
      if [ "$base_only" != "$base" ] && [ "$base_only" != "$simple" ] && [ ! -f "$out/lib/swt-native/$base_only" ]; then
        ln -sf "$base" "$out/lib/swt-native/$base_only"
      fi
    done

    # Fix modelio.sh paths
    substituteInPlace "$out/lib/modelio.sh" \
      --replace-fail 'MODELIO_PATH="$(getModelioInstallPath "$0")"' \
        "MODELIO_PATH=$out/lib" \
      --replace-fail '/etc/modelio-open-source5.2/modelio.config' \
        "$out/lib/modelio.config"

    chmod +x "$out/lib/modelio" "$out/lib/modelio.sh" 2>/dev/null || true

    # Add java.library.path for SWT native libraries
    echo "-Djava.library.path=$out/lib/swt-native" >> "$out/lib/modelio.ini"

    makeWrapper "$out/lib/modelio.sh" "$out/bin/modelio" \
      --prefix LD_LIBRARY_PATH : "$out/lib/swt-native:${webkitCompat}/lib" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --prefix PATH : "${openjdk11}/bin" \
      --set JAVA_HOME "${openjdk11.home}" \
      --set SWT_GTK3 "1" \
      --set SWT_WEBKIT2 "1" \
      --set GDK_BACKEND "x11" \
      --set UBUNTU_MENUPROXY "0" \
      --set LIBOVERLAY_SCROLLBAR "0"

    # Fix desktop file
    if [ -f "$out/share/applications/modelio-open-source${modelioVersion}.desktop" ]; then
      substituteInPlace "$out/share/applications/modelio-open-source${modelioVersion}.desktop" \
        --replace-fail "/usr/bin/modelio-open-source${modelioVersion}" "modelio"
    fi
  '';

  meta = {
    description = "Open Source UML/BPMN modeler (Eclipse RCP-based)";
    longDescription = ''
      Modelio is a modeling solution offering a wide range of functionality
      based on commonly used standards for enterprise architecture, software
      development and systems engineering. It supports UML2 and BPMN standards.
    '';
    homepage = "https://www.modelio.org/";
    changelog = "https://github.com/ModelioOpenSource/Modelio/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ alsebrus ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "modelio";
  };
})
