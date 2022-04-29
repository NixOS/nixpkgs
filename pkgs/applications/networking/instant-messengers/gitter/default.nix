{ lib, stdenv, alsa-lib, atk, at-spi2-core, cairo, cups, dbus, dpkg, expat, fetchurl
, fontconfig, freetype, gdk-pixbuf, glib, gtk3,  libdrm, libX11
, libXScrnSaver, libXcomposite, libXcursor, libXdamage, libXext, libXfixes
, libXi, libXrandr, libXrender, libXtst, libappindicator-gtk3, libcxx
, libnotify, libpulseaudio, libxcb, makeDesktopItem, makeWrapper, mesa, nspr, nss
, pango, systemd }:

let gitterDirectorySuffix = "opt/gitter";
   libPath = lib.makeLibraryPath [
     alsa-lib
     atk
     at-spi2-core
     cairo
     cups
     dbus
     expat
     fontconfig
     freetype
     gdk-pixbuf
     glib
     gtk3
     libX11
     libXScrnSaver
     libXcomposite
     libXcursor
     libXdamage
     libXext
     libXfixes
     libXi
     libXrandr
     libXrender
     libXtst
     libappindicator-gtk3
     libcxx
     libdrm
     libnotify
     libpulseaudio
     libxcb
     mesa
     nspr
     nss
     pango
     stdenv.cc.cc
     systemd
  ];
    doELFPatch = target: ''
      patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
         --set-rpath "$out/${gitterDirectorySuffix}/lib:${libPath}" \
         $out/${gitterDirectorySuffix}/${target}
       '';
in stdenv.mkDerivation rec {
  pname = "gitter";
  version = "5.0.1";

  src = fetchurl {
    url = "https://update.gitter.im/linux64/${pname}_${version}_amd64.deb";
    sha256 = "1ps9akylqrril4902r8mi0mprm0hb5wra51ry6c1rb5xz5nrzgh1";
  };

  nativeBuildInputs = [ makeWrapper dpkg ];

  unpackPhase = "dpkg -x $src .";

  installPhase = ''
    mkdir -p $out/{bin,opt/gitter,share/pixmaps}
    mv ./opt/Gitter/linux64/* $out/opt/gitter

    ${doELFPatch "Gitter"}
    ${doELFPatch "nacl_helper"}
    ${doELFPatch "minidump_stackwalk"}
    ${doELFPatch "nwjc"}
    ${doELFPatch "chromedriver"}
    ${doELFPatch "payload"}

    patchelf --set-rpath "$out/${gitterDirectorySuffix}/lib:${libPath}" \
         $out/${gitterDirectorySuffix}/lib/libnw.so

    wrapProgram $out/${gitterDirectorySuffix}/Gitter --prefix LD_LIBRARY_PATH : ${libPath}

    ln -s $out/${gitterDirectorySuffix}/Gitter $out/bin/
    ln -s $out/${gitterDirectorySuffix}/logo.png $out/share/pixmaps/gitter.png
    ln -s "${desktopItem}/share/applications" $out/share/
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "Gitter";
    icon = pname;
    desktopName = "Gitter";
    genericName = meta.description;
    categories = [ "Network" "InstantMessaging" ];
  };

  meta = with lib; {
    description = "Where developers come to talk";
    downloadPage = "https://gitter.im/apps";
    license = licenses.mit;
    maintainers = [ maintainers.imalison ];
    platforms = [ "x86_64-linux" ];
  };
}
