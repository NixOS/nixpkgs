{
  lib,
  stdenv,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,

  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  ffmpeg_7,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libGL,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxshmfence,
  libxtst,
  libxxf86vm,
  nspr,
  nss,
  pango,
  systemd,
  zlib,
}:

let
  desktopItem = makeDesktopItem {
    name = "ib-tws";
    desktopName = "IBKR Trader Workstation";
    exec = "tws";
    icon = "tws";
    categories = [
      "Office"
      "Finance"
    ];
    startupWMClass = "install4j-jclient-LoginFrame";
  };

  runtimeLibraries = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    ffmpeg_7
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libgbm
    libGL
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxi
    libxkbcommon
    libxrandr
    libxrender
    libxshmfence
    libxtst
    libxxf86vm
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    systemd
    zlib
  ];

  runtimeLibraryPath = lib.makeLibraryPath runtimeLibraries;
in
stdenv.mkDerivation {
  pname = "ib-tws";
  version = "10.45.1g";

  # IBKR only publishes rolling-channel installer URLs (latest/stable), not
  # per-version ones, so the URL is constant and the version is just a label.
  # The pinned hash still makes each eval reproducible and fails closed when
  # IBKR rotates the bytes; passthru.updateScript re-pins hash + version on bump.
  # We use stable here so there are fewer version bumps.
  src = fetchurl {
    url = "https://download2.interactivebrokers.com/installers/tws/stable-standalone/tws-stable-standalone-linux-x64.sh";
    hash = "sha256-Il/ULIpQbI9+GEuMNaqBYA0jJfSnDT7ZvyXEjJJn5MY=";
    executable = true;
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [ desktopItem ];

  passthru.updateScript = ./update.sh;

  installPhase = ''
    runHook preInstall

    install4jRoot="$TMPDIR/install4j"
    mkdir -p "$install4jRoot" "$out/bin" "$out/jre"
    export FONTCONFIG_FILE="${fontconfig.out}/etc/fonts/fonts.conf"
    export XDG_CACHE_HOME="$TMPDIR/xdg-cache"
    mkdir -p "$XDG_CACHE_HOME"

    payloadSize="$(sed -nE 's/^tail -c ([0-9]+).*/\1/p' "$src")"
    installerSize="$(stat -c %s "$src")"

    if [ -z "$payloadSize" ]; then
      echo "could not determine embedded install4j payload size" >&2
      exit 1
    fi

    tail -c "$payloadSize" "$src" | tar -xzf - -C "$install4jRoot"
    tar -xzf "$install4jRoot/jre.tar.gz" -C "$out/jre"

    dataSize="$(sed -nE 's/^file\.size\.0=([0-9]+)/\1/p' "$install4jRoot/stats.properties")"
    if [ -z "$dataSize" ]; then
      echo "could not determine install4j data payload size" >&2
      exit 1
    fi

    dataOffset=$((installerSize - payloadSize - dataSize))
    dd \
      if="$src" \
      of="$install4jRoot/0.dat" \
      iflag=skip_bytes,count_bytes \
      skip="$dataOffset" \
      count="$dataSize" \
      status=none

    dynamicLinker="$(cat "$NIX_CC/nix-support/dynamic-linker")"
    jreLibraryPath="${lib.makeLibraryPath [ zlib ]}:$out/jre/lib:$out/jre/lib/server"

    for file in "$out"/jre/bin/* "$out"/jre/lib/jexec "$out"/jre/lib/jspawnhelper; do
      if [ -f "$file" ] && [ -x "$file" ]; then
        patchelf \
          --set-interpreter "$dynamicLinker" \
          --set-rpath "$jreLibraryPath" \
          "$file"
      fi
    done

    "$out/jre/bin/java" -version

    # install4j embeds its entry class name as a literal "Installer<N>" string.
    # We assume the first match is the launcher class; this has held across
    # releases but is unverified per-version, so revisit if a bump fails here.
    installerClass="$(grep -aoE 'Installer[0-9]+' "$src" | head -n1)"
    if [ -z "$installerClass" ]; then
      echo "could not determine install4j installer class" >&2
      exit 1
    fi

    mkdir -p "$TMPDIR/tws-config"
    (
      cd "$install4jRoot"
      export INSTALL4J_JAVA_HOME="$out/jre"
      export LD_LIBRARY_PATH="${runtimeLibraryPath}:''${LD_LIBRARY_PATH-}"

      "$out/jre/bin/java" \
        -DjtsConfigDir="$TMPDIR/tws-config" \
        -classpath "i4jruntime.jar:launcher0.jar" \
        "install4j.$installerClass" \
        -q \
        -dir "$out"
    )

    makeWrapper "$out/tws" "$out/bin/tws" \
      --run "mkdir -p \"\$HOME/.tws\"" \
      --set INSTALL4J_JAVA_HOME "$out/jre" \
      --prefix LD_LIBRARY_PATH : "${runtimeLibraryPath}" \
      --add-flags "-J-DjtsConfigDir=\$HOME/.tws" \
      --add-flags "-J-Dawt.useSystemAAFontSettings=lcd" \
      --add-flags "-J-Dswing.aatext=true"

    install -Dm644 "$out/.install4j/tws.png" "$out/share/icons/hicolor/128x128/apps/tws.png"

    runHook postInstall
  '';

  meta = {
    description = "Desktop trading platform for Interactive Brokers";
    homepage = "https://www.interactivebrokers.com/en/trading/tws.php";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ adamyi ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "tws";
  };
}
