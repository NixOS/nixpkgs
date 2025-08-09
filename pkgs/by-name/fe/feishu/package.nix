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
  writeScript,

  # for custom command line arguments, e.g. "--use-gl=desktop"
  commandLineArgs ? "",
}:

let
  sources = {
    x86_64-linux = fetchurl {
      url = "https://sf3-cn.feishucdn.com/obj/ee-appcenter/91e64286/Feishu-linux_x64-7.42.17.deb";
      sha256 = "sha256-Rsq+xQAyi7I1WcnkXzhPEgbUyfXU9XPVKIuv6Z9H5VA=";
    };
    aarch64-linux = fetchurl {
      url = "https://sf3-cn.feishucdn.com/obj/ee-appcenter/49127814/Feishu-linux_arm64-7.42.17.deb";
      sha256 = "sha256-UykQk8R8EDsHmRGy9BfDXhEZFlYT16bAkRuLXFZJDHw=";
    };
  };

  supportedPlatforms = [
    "x86_64-linux"
    "aarch64-linux"
  ];

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
in
stdenv.mkDerivation {
  version = "7.42.17";
  pname = "feishu";

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
    # This deb file contains a setuid binary,
    # so 'dpkg -x' doesn't work here.
    dpkg --fsys-tarfile $src | tar --extract
    mkdir -p $out
    mv usr/share $out/
    mv opt/ $out/

    substituteInPlace $out/share/applications/bytedance-feishu.desktop \
      --replace /usr/bin/bytedance-feishu-stable $out/opt/bytedance/feishu/bytedance-feishu

    # Wrap feishu and vulcan
    # Feishu is the main executable, vulcan is the builtin browser
    for executable in $out/opt/bytedance/feishu/{feishu,vulcan/vulcan}; do
      # FIXME: Add back NIXOS_OZONE_WL support once upstream fixes the crash on native Wayland (see #318035)
      wrapProgram $executable \
        --prefix XDG_DATA_DIRS    :  "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
        --prefix LD_LIBRARY_PATH  :  ${rpath}:$out/opt/bytedance/feishu:${addDriverRunpath.driverLink}/share \
        ${lib.optionalString (
          commandLineArgs != ""
        ) "--add-flags ${lib.escapeShellArg commandLineArgs}"}
    done

    mkdir -p $out/share/icons/hicolor
    base="$out/opt/bytedance/feishu"
    for size in 16 24 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      ln -s $base/product_logo_$size.png $out/share/icons/hicolor/''${size}x''${size}/apps/bytedance-feishu.png
    done

    mkdir -p $out/bin
    ln -s $out/opt/bytedance/feishu/bytedance-feishu $out/bin/bytedance-feishu
  '';

  passthru = {
    inherit sources;
    updateScript = writeScript "update-feishu.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts

      for platform in ${lib.escapeShellArgs supportedPlatforms}; do
        if [ $platform = "x86_64-linux" ]; then
          platform_id=10
        elif [ $platform = "aarch64-linux" ]; then
          platform_id=12
        else
          echo "Unsupported platform: $platform"
          exit 1
        fi
        package_info=$(curl -sf "https://www.feishu.cn/api/package_info?platform=$platform_id")
        update_link=$(echo $package_info | jq -r '.data.download_link' | sed 's/lf[0-9]*-ug-sign.feishucdn.com/sf3-cn.feishucdn.com\/obj/;s/?.*$//')
        new_version=$(echo $package_info | jq -r '.data.version_number' | sed -n 's/.*@V//p')
        sha256_hash=$(nix-prefetch-url $update_link)
        sri_hash=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 $sha256_hash)
        update-source-version feishu $new_version $sri_hash $update_link --system=$platform --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    description = "All-in-one collaboration suite";
    homepage = "https://www.feishu.cn/en/";
    downloadPage = "https://www.feishu.cn/en/#en_home_download_block";
    license = lib.licenses.unfree;
    platforms = supportedPlatforms;
    maintainers = with lib.maintainers; [ billhuang ];
    mainProgram = "bytedance-feishu";
  };
}
