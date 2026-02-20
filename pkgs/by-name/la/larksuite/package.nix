{
  addDriverRunpath,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  cairo,
  cups,
  dbus,
  dpkg,
  expat,
  fetchurl,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  glibc,
  gnutls,
  gtk3,
  lib,
  libGL,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libappindicator-gtk3,
  libcxx,
  libdbusmenu,
  libdrm,
  libgcrypt,
  libglvnd,
  libnotify,
  libpulseaudio,
  libuuid,
  libxcb,
  libxkbcommon,
  libxkbfile,
  libxshmfence,
  makeShellWrapper,
  libgbm,
  nspr,
  nss,
  pango,
  pciutils,
  pipewire,
  pixman,
  stdenv,
  systemd,
  wayland,
  xdg-utils,
  writeShellScript,

  # for custom command line arguments, e.g. "--use-gl=desktop"
  commandLineArgs ? "",
}:

let
  sources = {
    x86_64-linux = fetchurl {
      url = "https://lf16-larkversion.larksuitecdn.com/obj/lark-version-sg/967dd7e4/Lark-linux_x64-7.59.12.deb";
      hash = "sha256-Oa5tCn2l4zJzafzoxLfAZVXu0zWILKv+DeWJsQRsZtI=";
    };
    aarch64-linux = fetchurl {
      url = "https://lf16-larkversion.larksuitecdn.com/obj/lark-version-sg/2d8485bc/Lark-linux_arm64-7.59.12.deb";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  };

  rpath = lib.makeLibraryPath [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    glibc
    gnutls
    libGL
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libappindicator-gtk3
    libcxx
    libdbusmenu
    libdrm
    libgcrypt
    libglvnd
    libnotify
    libpulseaudio
    libuuid
    libxcb
    libxkbcommon
    libxkbfile
    libxshmfence
    libgbm
    nspr
    nss
    pango
    pciutils
    pipewire
    pixman
    stdenv.cc.cc
    systemd
    wayland
    xdg-utils
  ];

  pname = "larksuite";
  version = "7.59.12";

in
stdenv.mkDerivation {
  inherit pname version;

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    makeShellWrapper
    dpkg
  ];

  buildInputs = [
    gtk3

    # for autopatchelf
    alsa-lib
    cups
    libXdamage
    libXtst
    libdrm
    libgcrypt
    libpulseaudio
    libxshmfence
    libgbm
    nspr
    nss
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    # This deb file contains a setuid binary,
    # so 'dpkg -x' doesn't work here.
    dpkg --fsys-tarfile $src | tar --extract
    mkdir -p $out
    mv usr/share $out/
    mv opt/ $out/

    substituteInPlace $out/share/applications/bytedance-lark.desktop \
      --replace-fail /usr/bin/bytedance-lark-stable $out/opt/bytedance/lark/bytedance-lark

    # Wrap lark, vulcan, and video_conference_sdk
    # - lark: main executable
    # - vulcan/vulcan: Electron browser used for rendering
    # - video_conference_sdk: video meeting child process
    for executable in $out/opt/bytedance/lark/{lark,vulcan/vulcan,video_conference_sdk}; do
      wrapProgram $executable \
        --set ELECTRON_DISABLE_SANDBOX 1 \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
        --prefix LD_LIBRARY_PATH : ${rpath}:$out/opt/bytedance/lark:${addDriverRunpath.driverLink}/share \
        ${lib.optionalString (
          commandLineArgs != ""
        ) "--add-flags ${lib.escapeShellArg commandLineArgs}"}
    done

    mkdir -p $out/share/icons/hicolor
    base="$out/opt/bytedance/lark"
    for size in 16 24 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      if [ -f "$base/product_logo_$size.png" ]; then
        ln -s $base/product_logo_$size.png $out/share/icons/hicolor/''${size}x''${size}/apps/bytedance-lark.png
      fi
    done

    mkdir -p $out/bin
    ln -s $out/opt/bytedance/lark/lark $out/bin/lark

    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = writeShellScript "update-larksuite" ''
      set -euo pipefail

      API_URL="https://www.larksuite.com/api/downloads"

      fetch_version() {
        local key="$1"
        curl -sf "$API_URL" | jq -r ".versions.$key"
      }

      for platform in x86_64-linux aarch64-linux; do
        case "$platform" in
          x86_64-linux) version_key="Linux_deb_x64" ;;
          aarch64-linux) version_key="Linux_deb_arm" ;;
        esac

        info=$(fetch_version "$version_key")
        url=$(echo "$info" | jq -r '.download_link')
        version=$(echo "$info" | jq -r '.version_number' | sed 's/.*@V//')

        echo "Platform: $platform"
        echo "  URL: $url"
        echo "  Version: $version"

        hash=$(nix-prefetch-url "$url")
        sri=$(nix hash to-sri --type sha256 "$hash")
        echo "  Hash: $sri"

        # Update the file using sed
        pkgfile=${./.}
        if [ -w "$pkgfile" ]; then
          sed -i "s|url = \".*$platform.*\";|url = \"$url\";|" "$pkgfile"
          sed -i "/$platform/,/hash = /s|hash = \".*\";|hash = \"$sri\";|" "$pkgfile"
        fi
        echo ""
      done
    '';
  };

  meta = {
    description = "Lark is a next-generation office suite that integrates messaging, schedule management, collaborative documents, video meeting, and various apps in one platform";
    homepage = "https://www.larksuite.com";
    downloadPage = "https://www.larksuite.com/downloads";
    changelog = "https://www.larksuite.com/hc/en-us/articles/360048663434";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames sources;
    maintainers = with lib.maintainers; [ adamcolwell ];
    mainProgram = "lark";
  };
}
