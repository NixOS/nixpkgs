{ lib, stdenv, fetchurl, dpkg
, alsa-lib, atk, cairo, cups, curl, dbus, expat, fontconfig, freetype, gdk-pixbuf, glib, glibc, gnome
, gtk3, libappindicator-gtk3, libnotify, libpulseaudio, libsecret, libv4l, nspr, nss, pango, systemd, wrapGAppsHook, xorg
, at-spi2-atk, libuuid, at-spi2-core, libdrm, mesa, libxkbcommon, libxshmfence }:

let

  # Please keep the version x.y.0.z and do not update to x.y.76.z because the
  # source of the latter disappears much faster.
  version = "8.80.0.143";

  rpath = lib.makeLibraryPath [
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    glib
    glibc
    libsecret
    libuuid

    gdk-pixbuf
    gtk3
    libappindicator-gtk3

    gnome.gnome-keyring

    libnotify
    libpulseaudio
    nspr
    nss
    pango
    stdenv.cc.cc
    systemd

    libv4l
    libdrm
    mesa
    libxkbcommon
    libxshmfence
    xorg.libxkbfile
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libXScrnSaver
    xorg.libxcb
  ] + ":${stdenv.cc.cc.lib}/lib64";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        urls = [
          "https://repo.skype.com/deb/pool/main/s/skypeforlinux/skypeforlinux_${version}_amd64.deb"
          "https://mirror.cs.uchicago.edu/skype/pool/main/s/skypeforlinux/skypeforlinux_${version}_amd64.deb"
          "https://web.archive.org/web/https://repo.skype.com/deb/pool/main/s/skypeforlinux/skypeforlinux_${version}_amd64.deb"
        ];
        sha256 = "sha256-SLypP+ZRHMWeB3KuvmmYb0Y1T3ipSpWNiYYQIzMCDDY=";
      }
    else
      throw "Skype for linux is not supported on ${stdenv.hostPlatform.system}";

in stdenv.mkDerivation {
  pname = "skypeforlinux";
  inherit version;

  system = "x86_64-linux";

  inherit src;

  nativeBuildInputs = [
    wrapGAppsHook
    glib # For setup hook populating GSETTINGS_SCHEMA_PATH
  ];

  buildInputs = [ dpkg ];

  dontUnpack = true;
  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    cp -av $out/usr/* $out
    rm -rf $out/opt $out/usr
    rm $out/bin/skypeforlinux

    ln -s "$out/share/skypeforlinux/skypeforlinux" "$out/bin/skypeforlinux"

    # Otherwise it looks "suspicious"
    chmod -R g-w $out
  '';

  postFixup = ''
    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* -or -name \*.node\* \) ); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath}:$out/share/skypeforlinux $file || true
    done

    # Fix the desktop link
    substituteInPlace $out/share/applications/skypeforlinux.desktop \
      --replace /usr/bin/ $out/bin/
    substituteInPlace $out/share/applications/skypeforlinux-share.desktop \
      --replace /usr/bin/ $out/bin/
    substituteInPlace $out/share/kservices5/ServiceMenus/skypeforlinux.desktop \
      --replace /usr/bin/ $out/bin/
  '';

  meta = with lib; {
    description = "Linux client for skype";
    homepage = "https://www.skype.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ panaeon jraygauthier ];
    platforms = [ "x86_64-linux" ];
  };
}
