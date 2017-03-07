{ fetchurl, stdenv, dpkg, makeWrapper, which
, alsaLib, dbus, expat, fontconfig, freetype, gcc, glib, libcap
, orc, libxml2, libxslt, nss, nspr, sqlite, xorg, zlib
, libxkbcommon
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let
  arch32 = "i686-linux";
  arch64 = "x86_64-linux";

  arch = if stdenv.system == arch32
    then "i386"
    else "amd64";

  shortVersion = "1.17.7-stable";

  version = "${shortVersion}_${arch}";

  url = "http://desktop-download.mendeley.com/download/apt/pool/main/m/mendeleydesktop/mendeleydesktop_${version}.deb";
  sha256 = if stdenv.system == arch32
    then "1frzp5glnxmcad21ilnd5ghs6n1x21w888xi1wbm6dqbfna71p9h"
    else "0nsfrx3blap3n3q7pn1l69h9v8naqhlmds2vqfxijx54y396xy1x";

  deps = [
    alsaLib
    dbus
    expat
    fontconfig
    freetype
    gcc.cc
    glib
    libcap
    libxml2
    libxslt
    orc
    nspr
    nss
    sqlite
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
    libxkbcommon
    xorg.libxcb
    xorg.libICE
    xorg.libSM

    zlib
#     qt55.qtbase
#     qt55.qtdeclarative
#     qt55.qtsvg
#     qt55.qtwebkit
  ];

in stdenv.mkDerivation {
  name = "mendeley-${version}";

  src = fetchurl {
    url = url;
    sha256 = sha256;
  };

  buildInputs = [ dpkg makeWrapper which ];

  unpackPhase = "true";

  installPhase = ''
    dpkg-deb -x $src $out
    mv $out/opt/mendeleydesktop/{bin,lib,plugins,share} $out

    interpreter=$(patchelf --print-interpreter $(readlink -f $(which patchelf)))
    patchelf --set-interpreter $interpreter $out/bin/mendeleydesktop

    librarypath="${stdenv.lib.makeLibraryPath deps}:$out/lib:$out/lib/qt"
    wrapProgram $out/bin/mendeleydesktop \
      --prefix LD_LIBRARY_PATH : "$librarypath" \
      --set QT_PLUGIN_PATH : "$out/plugins/qt/plugins" \
      --set QT_QPA_PLATFORM_PLUGIN_PATH "$out/plugins/qt/plugins/platforms" \
      --set QT_XKB_CONFIG_ROOT= "${libxkbcommon}/share/X11/xkb";

    # Remove vendored libraries
#     rm -rf $out/lib/qt

  '';

  dontStrip = true;
  dontPatchElf = true;

  meta = {
    homepage = http://www.mendeley.com;
    description = "A reference manager and academic social network";
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
  };

}
