{ fetchurl, stdenv, dpkg, which
, makeWrapper
, alsaLib
, desktop-file-utils
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
, qtbase
, qtsvg
, qtdeclarative
, qtwebchannel
, qtquickcontrols
, qtwebkit
, qtwebengine
, sqlite
, xorg
, xlibs
, zlib
# The provided wrapper does this, but since we don't use it
# we emulate the behavior.  The downside is that this
# will leave entries on your system after uninstalling mendeley.
# (they can be removed by running '$out/bin/install-mendeley-link-handler.sh -u')
, autorunLinkHandler ? true
# Update script
, writeScript
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let
  arch32 = "i686-linux";
  arch64 = "x86_64-linux";

  arch = if stdenv.system == arch32
    then "i386"
    else "amd64";

  shortVersion = "1.17.13-stable";

  version = "${shortVersion}_${arch}";

  url = "http://desktop-download.mendeley.com/download/apt/pool/main/m/mendeleydesktop/mendeleydesktop_${version}.deb";
  sha256 = if stdenv.system == arch32
    then "0q4x62k00whmq8lskphpcxc610cvclxzcr5k0v7pxjxs9sx5yx43"
    else "01ylyily1hip35z0d4qkdpbzp5yn4r015psc5773xsqlgrnlwjm3";

  deps = [
    qtbase
    qtsvg
    qtdeclarative
    qtwebchannel
    qtquickcontrols
    qtwebkit
    qtwebengine
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

  propagatedUserEnvPkgs = [ gconf ];

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
      --prefix PATH ':' ${stdenv.lib.makeBinPath [ which gconf desktop-file-utils ] }
  '';

  dontStrip = true;
  dontPatchElf = true;

  updateScript = import ./update.nix { inherit writeScript; };

  meta = with stdenv.lib; {
    homepage = http://www.mendeley.com;
    description = "A reference manager and academic social network";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers  = with maintainers; [ dtzWill ];
  };

}
