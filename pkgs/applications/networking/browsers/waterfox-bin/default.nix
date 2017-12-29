{ stdenv, fetchurl, config, makeWrapper, makeDesktopItem
, alsaLib
, at_spi2_atk
, atk
, cairo
, cups
, curl
, dbus_glib
, dbus_libs
, fontconfig
, freetype
, gdk_pixbuf
, glib
, glibc
, gst-plugins-base
, gstreamer
, gtk2
, gtk3
, kerberos
, libX11
, libXScrnSaver
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXinerama
, libXrender
, libXt
, libcanberra_gtk2
, mesa
, nspr
, nss
, pango
, writeScript
, xidel
, coreutils
, gnused
, gnugrep
, gnupg
}:

with stdenv.lib;

let
  # Upstream source
  version = "56.0.1";
  lang = "en-US";

  srcs = {
    "x86_64-linux" = fetchurl {
      url = "https://storage-waterfox.netdna-ssl.com/releases/linux64/installer/waterfox-${version}.${lang}.linux-x86_64.tar.bz2";
      sha512 = "82e83f375a06dbe94bd5d7aecaa6da246b622574547baf7d54d27371dfdd0f6499f8302d3d24000302897648a112e1c286d1bb7500a91b03fa860645241225d5";
    };
  };
in

stdenv.mkDerivation rec {
  name = "waterfox-bin-${version}";
  inherit version;

  src = srcs."${stdenv.system}" or (throw "unsupported system: ${stdenv.system}");

  preferLocalBuild = true;
  allowSubstitutes = false;

  libPath = makeLibraryPath ([
    stdenv.cc.cc
    alsaLib
    at_spi2_atk
    atk
    cairo
    cups
    curl
    dbus_glib
    dbus_libs
    fontconfig
    freetype
    gdk_pixbuf
    glib
    glibc
    gst-plugins-base
    gstreamer
    gtk2
    gtk3
    kerberos
    libX11
    libXScrnSaver
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXinerama
    libXrender
    libXt
    libcanberra_gtk2
    mesa
    nspr
    nss
    pango
  ]);

  desktopItem = makeDesktopItem {
    name = "waterfox";
    exec = "waterfox";
    icon = "waterfox";
    desktopName = "Waterfox";
    genericName = "Web Browser";
    mimeType = stdenv.lib.concatStringsSep ";" [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
      "x-scheme-handler/mailto"
      "x-scheme-handler/webcal"
      "x-scheme-handler/about"
      "x-scheme-handler/unknown"
    ];
    comment = "Browse the World Wide Web";
    categories = "Application;Network;WebBrowser;";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p "$prefix/opt/waterfox-bin-${version}"
    tar -xf "${src}" -C "$prefix/opt/waterfox-bin-${version}" --strip-components=1

    mkdir -p "$out/bin"
    ln -s "$prefix/opt/waterfox-bin-${version}/waterfox" "$out/bin/"

    for executable in \
      waterfox waterfox-bin plugin-container updater
    do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        "$prefix/opt/waterfox-bin-${version}/$executable"
    done

    wrapProgram "$out/bin/waterfox" \
      --argv0 "$out/bin/.waterfox-wrapped" \
      --set LD_LIBRARY_PATH "$libPath" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:" \
      --suffix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
  '';

  meta = with stdenv.lib; {
    description = "A web browser (binary package)";
    homepage = https://www.waterfoxproject.org/;
    license = {
      free = false;
      url = https://www.waterfoxproject.org/terms;
    };
    maintainers = with stdenv.lib.maintainers; [ iamale ];
    platforms = platforms.linux;
  };
}
