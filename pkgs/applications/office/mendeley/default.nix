{ fetchurl, stdenv, dpkg, which
, makeWrapper
, alsaLib
, desktop_file_utils
, dbus
, libcap
, fontconfig
, freetype
, gcc
, gconf
, glib
, icu
, libxml2
, libxslt
, orc
, nss
, nspr
, qt5
, sqlite
, xorg
, xlibs
, zlib
# The provided wrapper does this, but since we don't use it
# we emulate the behavior.  The downside is that this
# will leave entries on your system after uninstalling mendeley.
# (they can be removed by running '$out/bin/install-mendeley-link-handler.sh -u')
, autorunLinkHandler ? true
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let
  arch32 = "i686-linux";
  arch64 = "x86_64-linux";

  arch = if stdenv.system == arch32
    then "i386"
    else "amd64";

  shortVersion = "1.17.10-stable";

  version = "${shortVersion}_${arch}";

  url = "http://desktop-download.mendeley.com/download/apt/pool/main/m/mendeleydesktop/mendeleydesktop_${version}.deb";
  sha256 = if stdenv.system == arch32
    then "0sc9fsprdpl39q8wqbjp59pnr10c1a8gss60b81h54agjni55yrg"
    else "02ncfdxcrdwghpch2nlfhc7d0vgjsfqn8sxjkb5yn4bf5wi8z9bq";

  deps = [
    qt5.qtbase
    qt5.qtsvg
    qt5.qtdeclarative
    qt5.qtwebchannel
    qt5.qtquickcontrols
    qt5.qtwebkit
    qt5.qtwebengine
    alsaLib
    dbus
    freetype
    fontconfig
    gcc.cc
    gconf
    glib
    icu
    libcap
    libxml2
    libxslt
    nspr
    nss
    orc
    sqlite
    xorg.libX11
    xlibs.xcbutilkeysyms
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXext
    xorg.libXrender
    xorg.libXi
    xorg.libXcursor
    xorg.libXtst
    xorg.libXrandr
    xorg.xcbutilimage
    zlib
  ];

in

stdenv.mkDerivation {
  name = "mendeley-${version}";

  src = fetchurl {
    url = url;
    sha256 = sha256;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ dpkg which ] ++ deps;

  unpackPhase = "true";

  installPhase = ''
    dpkg-deb -x $src $out
    mv $out/opt/mendeleydesktop/{bin,lib,share} $out

    interpreter=$(patchelf --print-interpreter $(readlink -f $(which patchelf)))
    patchelf --set-interpreter $interpreter \
             --set-rpath ${stdenv.lib.makeLibraryPath deps}:$out/lib \
             $out/bin/mendeleydesktop
    paxmark m $out/bin/mendeleydesktop

    wrapProgram $out/bin/mendeleydesktop \
      --add-flags "--unix-distro-build" \
      ${stdenv.lib.optionalString autorunLinkHandler # ignore errors installing the link handler
      ''--run "$out/bin/install-mendeley-link-handler.sh $out/bin/mendeleydesktop ||:"''}

    # Remove bundled qt bits
    rm -rf $out/lib/qt
    rm $out/bin/qt* $out/bin/Qt*

    # Patch up link handler script
    wrapProgram $out/bin/install-mendeley-link-handler.sh \
      --prefix PATH ':' ${stdenv.lib.makeBinPath [ which gconf desktop_file_utils ] }
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
