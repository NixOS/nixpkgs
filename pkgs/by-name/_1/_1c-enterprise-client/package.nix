{ stdenv
, dpkg
, autoPatchelfHook
, makeWrapper
, _1c-enterprise-common
, _1c-enterprise-server
, glib
, glibc
, gtk3
, pango
, atk
, cairo
, gdk-pixbuf
, freetype
, fontconfig
, dbus
, nss
, nspr
, alsa-lib
, cups
, expat
, lib
, libdrm
, xorg
, openssl
, libxml2
, zlib
, requireFile
, openal
, libssh
, libGLU
, webkitgtk_4_0
, webkitgtk_4_1
, libsoup_2_4
, libGL
, e2fsprogs
, patchelf
, gsettings-desktop-schemas
, copyDesktopItems
, versions ? ""
, callPackage
, ...
}:

let
  v = callPackage ../_1c-enterprise {};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "_1c-enterprise-client";
  version = v.pkgVersion;
  pkgversion = v.pkgVersionStr;
  src = requireFile v.clientDebInfo;

  nativeBuildInputs = [
    dpkg
    patchelf
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    _1c-enterprise-common
    stdenv.cc.cc.lib
    glibc
    e2fsprogs
    glib
    gtk3
    pango
    atk
    cairo
    gdk-pixbuf
    freetype
    fontconfig
    dbus
    nss
    nspr
    alsa-lib
    cups
    expat
    libdrm
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi
    xorg.libXfixes
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXxf86vm
    openssl
    libxml2
    zlib
    openal
    libssh
    libGLU
    webkitgtk_4_0
    webkitgtk_4_1
    libsoup_2_4
    libGL
    gsettings-desktop-schemas
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';


  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/1cv8/{conf,common},share/applications,sbin}
    cp -r ./opt $out
    cp -r ./usr/share $out

    ln -sf ${_1c-enterprise-common}/opt/1cv8/x86_64/${finalAttrs.version}/* $out/opt/1cv8/x86_64/${finalAttrs.version}/
    ln -sf ${_1c-enterprise-server}/opt/1cv8/x86_64/${finalAttrs.version}/* $out/opt/1cv8/x86_64/${finalAttrs.version}/

    mv $out/opt/1cv8/x86_64/${finalAttrs.version}/1cestart-${finalAttrs.pkgversion}.desktop $out/share/applications/1cestart-${finalAttrs.pkgversion}.desktop

    runHook postInstall
  '';

  postInstall = ''
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/1cestart $out/opt/1cv8/common/1cestart
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/1cestart $out/bin/1cestart
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/1cv8 $out/bin/1cv8
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/1cv8c $out/bin/1cv8c
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/1cv8s $out/bin/1cv8s

    substituteInPlace $out/share/applications/1cestart-${finalAttrs.pkgversion}.desktop \
      --replace "/opt/1cv8/common/1cestart" "1cestart"
    substituteInPlace $out/share/applications/1cv8-${finalAttrs.pkgversion}.desktop \
      --replace "/opt/1cv8/x86_64/${finalAttrs.version}/1cv8" "1cv8"
    substituteInPlace $out/share/applications/1cv8c-${finalAttrs.pkgversion}.desktop \
      --replace "/opt/1cv8/x86_64/${finalAttrs.version}/1cv8c" "1cv8c"
    substituteInPlace $out/share/applications/1cv8s-${finalAttrs.pkgversion}.desktop \
      --replace "/opt/1cv8/x86_64/${finalAttrs.version}/1cv8s" "1cv8s"
  '';

  preFixup = ''
    addAutoPatchelfSearchPath "$out/opt/1cv8/x86_64/${finalAttrs.version}"
    addAutoPatchelfSearchPath "${_1c-enterprise-common}/opt/1cv8/x86_64/${finalAttrs.version}"
    addAutoPatchelfSearchPath "${_1c-enterprise-server}/opt/1cv8/x86_64/${finalAttrs.version}"
    autoPatchelf $out
  '';

  meta = with lib; {
    description = "1C Enterprise Client Full";
    homepage = "https://1c.ru";
    license = {
      fullName = "License agreement for 1C:Enterprise 8.3";
      url = "file://${out}/opt/1cv8/x86_64/${finalAttrs.version}/licenses/1CEnterprise_en.htm";
      free = false;
    };
    platforms = [ "x86_64-linux" ];
  };
})
