{ addOpenGLRunpath
, alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, autoPatchelfHook
, cairo
, cups
, dbus
, dpkg
, expat
, fetchurl
, fontconfig
, freetype
, gdk-pixbuf
, glib
, glibc
, gnutls
, gtk3
, lib
, libGL
, libX11
, libXScrnSaver
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXtst
, libappindicator-gtk3
, libcxx
, libdbusmenu
, libdrm
, libgcrypt
, libglvnd
, libnotify
, libuuid
, libxcb
, libxkbcommon
, libxkbfile
, libxshmfence
, makeShellWrapper
, mesa
, nspr
, nss
, pango
, pciutils
, pipewire
, pixman
, stdenv
, systemd
, wayland
, wrapGAppsHook
, xdg-utils

# for custom command line arguments, e.g. "--use-gl=desktop"
, commandLineArgs ? ""
}:

stdenv.mkDerivation rec {
  version = "5.14.14";
  pname = "feishu";
  packageHash = "2844ab12b34f"; # A hash value used in the download url

  src = fetchurl {
    url = "https://sf3-cn.feishucdn.com/obj/ee-appcenter/${packageHash}/Feishu-linux_x64-${version}.deb";
    sha256 = "c0ca999edc10d8ada08c46b33b15d7db0ced264248abd3ebfdb895d8457e1bec";
  };

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
    libdrm
    libxshmfence
    mesa
    nspr
    nss
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
    libuuid
    libxcb
    libxkbcommon
    libxkbfile
    libxshmfence
    mesa
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
      wrapProgram $executable \
        --prefix XDG_DATA_DIRS    :  "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
        --prefix LD_LIBRARY_PATH  :  ${rpath}:$out/opt/bytedance/feishu:${addOpenGLRunpath.driverLink}/share \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}" \
        ${lib.optionalString (commandLineArgs!="") "--add-flags ${lib.escapeShellArg commandLineArgs}"}
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

  meta = with lib; {
    description = "An all-in-one collaboration suite";
    homepage = "https://www.feishu.cn/en/";
    downloadPage = "https://www.feishu.cn/en/#en_home_download_block";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ billhuang ];
  };
}
