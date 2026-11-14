{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  jdk21,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  file,
  alsa-lib,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  libdrm,
  libxkbcommon,
  libx11,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxcb,
  libxcursor,
  libxi,
  libxinerama,
  libxrender,
  libxscrnsaver,
  libxtst,
  mesa,
  nspr,
  nss,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "komi-store";
  version = "1.9.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kurikomi-labs";
    repo = "komi-store";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oRGkXLoH8+bzy3NE2rdtW3qgqT2c+z2y0qmwosatAeg=";
  };

  # Desktop-only build: drop Android Gradle plugins/deps (no Android SDK in nix).
  patches = [
    ./compose-repo.patch
    ./build-logic-pluginmanagement.patch
    ./disable-android-convention.patch
    ./disable-android-composeapp.patch
  ];

  nativeBuildInputs = [
    gradle
    jdk21
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    file
    alsa-lib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libGL
    libdrm
    libxkbcommon
    mesa
    nspr
    nss
    pango
    libx11
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxinerama
    libxrandr
    libxrender
    libxscrnsaver
    libxtst
    libxcb
  ];

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk21}"
    "-Dfile.encoding=utf-8"
  ];

  gradleBuildTask = "composeApp:createDistributable";
  gradleUpdateTask = "composeApp:createDistributable";

  env.JAVA_HOME = jdk21;

  installPhase = ''
    runHook preInstall

    # Compose Multiplatform packageName = "Komi-Store"
    mkdir -p $out/opt/komi-store $out/bin
    cp -r composeApp/build/compose/binaries/main/app/Komi-Store/* $out/opt/komi-store/
    rm -rf $out/opt/komi-store/lib/runtime

    cat > $out/bin/komi-store <<'EOF'
    #!/usr/bin/env bash
    set -euo pipefail

    appdir="@out@/opt/komi-store/lib/app"
    cfg="$appdir/Komi-Store.cfg"
    classpath=""
    main_class=""
    java_opts=()

    while IFS= read -r line; do
      case "$line" in
        app.classpath=*)
          entry="''${line#app.classpath=}"
          entry="''${entry//\$APPDIR/$appdir}"
          if [ -z "$classpath" ]; then
            classpath="$entry"
          else
            classpath="$classpath:$entry"
          fi
          ;;
        app.mainclass=*)
          main_class="''${line#app.mainclass=}"
          ;;
        java-options=*)
          opt="''${line#java-options=}"
          opt="''${opt//\$APPDIR/$appdir}"
          java_opts+=("$opt")
          ;;
      esac
    done < "$cfg"

    if [ -z "$main_class" ]; then
      echo "Missing main class in $cfg" >&2
      exit 1
    fi

    exec "@jdk@/bin/java" \
      "''${java_opts[@]}" \
      -cp "$classpath" \
      "$main_class" \
      "$@"
    EOF
    substituteInPlace $out/bin/komi-store \
      --replace-fail "@out@" "$out" \
      --replace-fail "@jdk@" "${jdk21}"
    chmod +x $out/bin/komi-store

    install -Dm644 composeApp/src/jvmMain/resources/logo/app_icon.png \
      $out/share/icons/hicolor/512x512/apps/komi-store.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "komi-store";
      exec = "komi-store";
      icon = "komi-store";
      desktopName = "Komi Store";
      comment = finalAttrs.meta.description;
      categories = [ "Development" ];
    })
  ];

  meta = {
    description = "Cross-platform app store for GitHub releases";
    homepage = "https://github.com/kurikomi-labs/komi-store";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mio ];
    platforms = lib.platforms.linux;
    mainProgram = "Komi-Store";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
