{ fetchurl, lib, stdenv, mkDerivation, dpkg, which
, makeWrapper
, alsa-lib
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
, zlib
# The provided wrapper does this, but since we don't use it
# we emulate the behavior.  The downside is that this
# will leave entries on your system after uninstalling mendeley.
# (they can be removed by running '$out/bin/install-mendeley-link-handler.sh -u')
, autorunLinkHandler ? true
# Update script
, writeScript
, runtimeShell
}:

let
  arch32 = "i686-linux";

  arch = if stdenv.hostPlatform.system == arch32
    then "i386"
    else "amd64";

  shortVersion = "1.19.5-stable";

  version = "${shortVersion}_${arch}";

  url = "http://desktop-download.mendeley.com/download/apt/pool/main/m/mendeleydesktop/mendeleydesktop_${version}.deb";
  sha256 = if stdenv.hostPlatform.system == arch32
    then "01x83a44qlxi937b128y8y0px0q4w37g72z652lc42kv50dhyy3f"
    else "1cagqq0xziznaj97z30bqfhrwjv3a4h83ckhwigq35nhk1ggq1ry";

  deps = [
    qtbase
    qtsvg
    qtdeclarative
    qtwebchannel
    qtquickcontrols
    qtwebkit
    qtwebengine
    alsa-lib
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
    xorg.xcbutilkeysyms
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

mkDerivation {
  pname = "mendeley";
  inherit version;

  src = fetchurl {
    url = url;
    sha256 = sha256;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ dpkg which ] ++ deps;

  propagatedUserEnvPkgs = [ gconf ];

  dontUnpack = true;

  dontWrapQtApps = true;

  installPhase = ''
    dpkg-deb -x $src $out
    mv $out/opt/mendeleydesktop/{bin,lib,share} $out

    interpreter=$(patchelf --print-interpreter $(readlink -f $(which patchelf)))
    patchelf --set-interpreter $interpreter \
             --set-rpath ${lib.makeLibraryPath deps}:$out/lib \
             $out/bin/mendeleydesktop

    wrapQtApp $out/bin/mendeleydesktop \
      --add-flags "--unix-distro-build" \
      ${lib.optionalString autorunLinkHandler # ignore errors installing the link handler
      ''--run "$out/bin/install-mendeley-link-handler.sh $out/bin/mendeleydesktop ||:"''}

    # Remove bundled qt bits
    rm -rf $out/lib/qt
    rm $out/bin/qt* $out/bin/Qt*

    # Patch up link handler script
    wrapProgram $out/bin/install-mendeley-link-handler.sh \
      --prefix PATH ':' ${lib.makeBinPath [ which gconf desktop-file-utils ] }
  '';

  dontStrip = true;
  dontPatchELF = true;

  updateScript = import ./update.nix { inherit writeScript runtimeShell; };

  meta = with lib; {
    homepage = "https://www.mendeley.com";
    description = "A reference manager and academic social network";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers  = with maintainers; [ dtzWill ];
  };

}
