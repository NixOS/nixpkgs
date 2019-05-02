{ stdenv, fetchurl, dpkg, makeWrapper
, alsaLib, atk, cairo, cups, curl, dbus, expat, fontconfig, freetype, glib
, gnome2, gtk3, gdk_pixbuf, libnotify, libxcb, nspr, nss, pango
, systemd, xorg, xprintidle-ng }:

let

  version = "1.10.45";

  rpath = stdenv.lib.makeLibraryPath [
    alsaLib
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    glib
    gnome2.GConf
    gdk_pixbuf
    gtk3
    pango
    libnotify
    libxcb
    nspr
    nss
    stdenv.cc.cc
    systemd

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
  ] + ":${stdenv.cc.cc.lib}/lib64";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/johannesjo/super-productivity/releases/download/v${version}/superProductivity_${version}_amd64.deb";
        sha256 = "0jfi0lfijnhij9jvkhxgyvq8m1jzaym8n1c7707fv3hjh1h0vxn1";
      }
    else
      throw "super-productivity is not supported on ${stdenv.hostPlatform.system}";

in stdenv.mkDerivation {
  name = "super-productivity-${version}";

  inherit src;

  buildInputs = [
    dpkg
    gtk3  # needed for GSETTINGS_SCHEMAS_PATH
  ];

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = "dpkg -x $src .";

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -R usr/share $out/share
    cp -R opt $out/libexec

    # Otherwise it looks "suspicious"
    chmod -R g-w $out

    # set linker and rpath
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$out/libexec/superProductivity/superproductivity"
    patchelf --set-rpath ${rpath}:$out/libexec/superProductivity "$out/libexec/superProductivity/superproductivity"

    # wrapper for xdg_data_dirs and xprintidle path
    makeWrapper $out/libexec/superProductivity/superproductivity $out/bin/superproductivity \
      --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
      --prefix PATH : "${xprintidle-ng}/bin"

    # Fix the desktop link
    substituteInPlace $out/share/applications/superproductivity.desktop \
      --replace /opt/superProductivity/ $out/bin/

    runHook postInstall
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "To Do List / Time Tracker with Jira Integration.";
    homepage = https://super-productivity.com;
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ offline ];
  };
}
