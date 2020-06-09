{ alsaLib
, autoPatchelfHook
, cups
, dbus
, dpkg
, fetchurl
, fontconfig
, freetype
, glib
, lib
, libglvnd
, libsForQt5
, libXcomposite
, libXcursor
, libXdamage
, libXrandr
, libXtst
, libXi
, nspr
, nss
, nssTools
, qt5
, stdenv
, xlibsWrapper }:

stdenv.mkDerivation rec {
  pname = "mindmaster";
  version = "7";

  src = fetchurl {
    url = "https://www.edrawsoft.com/archives/${pname}-${version}-amd64.deb";
    sha256 = "1p0sjq6jmzp380jd9d8j2gy6lwqfyks2zkzhki1ynrjnky9fmaa7";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    alsaLib
    cups.lib
    dbus
    freetype
    fontconfig.lib
    glib
    libglvnd
    libsForQt5.fcitx-qt5
    libXcomposite
    libXcursor
    libXdamage
    libXrandr
    libXtst
    libXi
    nspr
    nss
    nssTools
    qt5.qtsvg
    stdenv.cc.cc.lib
    xlibsWrapper
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  dontStrip = true;
  
  installPhase = ''
    mkdir -p $out
    mv opt/ $out
    
    #strip usr dir
    mv usr/* $out

    cd $out

    # prepend $out to all references in desktop files
    find -name "*.desktop" -exec sed -E -i "s:/usr/lib:$out/lib:g" {} \;
  '';

  meta = with lib; {
    description = "Mind map visualiser";
    homepage = "https://www.edrawsoft.com/mindmaster";
    license = licenses.unfree;
    maintainers = with maintainers; [ skykanin ];
    platforms = platforms.linux;
  };
}
