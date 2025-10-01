#TODO LIST:
#1. Split to _1c-enterprise-common/_1c-enterprise-client/_1c-enterprise-server and symlink _1c-enterprise-server and _1c-enterprise-common to _1c-enterprise-client
#2. Add systemd and 1cv8usr:1cv8grp for _1c-enterprise-server
{ stdenv
, dpkg
, autoPatchelfHook
, makeWrapper
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
, requireFile # or use fetchurl
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
, ...
}:

let
  pkgName = "_1c-enterprise-client";
  pkgVersion = "8.3.27.1606";
  Version =  lib.versions.splitVersion pkgVersion;
  pkgVersion3 =  builtins.concatStringsSep "." (lib.take 3 Version);
  pkgVersionBuild = builtins.elemAt Version 3;
  pkgVersionStr = "${pkgVersion3}-${pkgVersionBuild}";
  # Define the deb files
  clientDeb = requireFile {
    name = "1c-enterprise-${pkgVersion}-client_${pkgVersionStr}_amd64.deb";
    url = "https://releases.1c.ru/project/Platform83";
    sha256 = "sha256-gTylZZNYM7mSxqwKGDQktF8swBl1cSkHIC0K833cnhQ=";
  };
  commonDeb = requireFile {
    name = "1c-enterprise-${pkgVersion}-common_${pkgVersionStr}_amd64.deb";
    url = "https://releases.1c.ru/project/Platform83";
    sha256 = "sha256-PGjttk+GIum/4yp9rwG5iRXhIkUkP35bNP2hVUpDB5s=";
  };
  serverDeb = requireFile {
    name = "1c-enterprise-${pkgVersion}-server_${pkgVersionStr}_amd64.deb";
    url = "https://releases.1c.ru/project/Platform83";
    sha256 = "sha256-l4vibq5/V78CgDwoIFJnS4PC2chXfPEyvOrcVnq+KNg=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = pkgName;
  version = pkgVersion;
  pkgversion = pkgVersionStr;
  src = ./.;

  nativeBuildInputs = [ dpkg patchelf autoPatchelfHook makeWrapper ];

  buildInputs = [
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
    copyDesktopItems
  ];

  unpackPhase = ''
   dpkg-deb -x ${clientDeb} .
   dpkg-deb -x ${commonDeb} .
   dpkg-deb -x ${serverDeb} .
  '';

  preInstall = ''
    mkdir -p $out/{bin,opt/1cv8/{conf,common},share/applications,sbin}
    cat > $out/sbin/ldconfig <<EOF
    #!${stdenv.shell}
    echo "ldconfig dummy"
    EOF
    chmod +x $out/sbin/ldconfig
    export PATH="/sbin:$PATH"
  '';

  installPhase = ''
    runHook preInstall

    cp -r ./opt $out
    cp -r ./usr/share $out
    find $out/opt/1cv8 -name 'libstdc++.so.6' -delete
    find $out/opt/1cv8 -name 'libcairo-v8.so' -delete
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
  '';

  postFixup = ''
    if [ -d $out/opt/1cv8 ]; then
      addAutoPatchelfSearchPath $out/opt/1cv8/x86_64/${finalAttrs.version}/
    fi
  '';

  meta = with lib; {
    description = "1C Enterprise Client Full";
    homepage = "https://1c.ru";
    license = {
      fullName = "License agreement for 1C:Enterprise 8.3";
      url = "file://${out}/opt/1cv8/x86_64/${finalAttrs.version}/licenses/1CEnterprise_en.htm ";
      free = false;
    };
    platforms = [ "x86_64-linux" ];
  };
})