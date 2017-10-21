{ stdenv, lib, fetchurl, makeDesktopItem, unzip, ant, jdk
# Optional, Jitsi still runs without, but you may pass null:
, alsaLib, dbus_libs, gtk2, libpulseaudio, openssl, xorg
}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "jitsi-${version}";
  version = "2.10.5550";

  src = fetchurl {
    url = "https://download.jitsi.org/jitsi/src/jitsi-src-${version}.zip";
    sha256 = "11vjchc3dnzj55x7c62wsm6masvwmij1ifkds917r1qvil1nzz6d";
  };

  patches = [ ./jitsi.patch ];

  jitsiItem = makeDesktopItem {
    name = "Jitsi";
    exec = "jitsi";
    comment = "VoIP and Instant Messaging client";
    desktopName = "Jitsi";
    genericName = "Instant Messaging";
    categories = "Application;Internet;";
  };

  libPath = lib.makeLibraryPath ([
    stdenv.cc.cc  # For libstdc++.
  ] ++ lib.filter (x: x != null) [
    alsaLib
    dbus_libs
    gtk2
    libpulseaudio
    openssl
  ] ++ lib.optionals (xorg != null) [
    xorg.libX11
    xorg.libXext
    xorg.libXScrnSaver
    xorg.libXv
  ]);

  nativeBuildInputs = [ unzip ];
  buildInputs = [ ant jdk ];

  buildPhase = ''ant make'';

  installPhase = ''
    mkdir -p $out
    cp -a lib $out/
    rm -rf $out/lib/native/solaris
    cp -a sc-bundles $out/
    mkdir $out/bin
    cp resources/install/generic/run.sh $out/bin/jitsi
    chmod +x $out/bin/jitsi
    substituteInPlace $out/bin/jitsi \
      --subst-var-by JAVA ${jdk}/bin/java \
      --subst-var-by EXTRALIBS ${gtk2.out}/lib
    sed -e 's,^java\ ,${jdk}/bin/java ,' -i $out/bin/jitsi
    patchShebangs $out
    libPath="$libPath:${jdk.home}/lib/${jdk.architecture}"
    find $out/ -type f -name '*.so' | while read file; do
      patchelf --set-rpath "$libPath" "$file" && \
          patchelf --shrink-rpath "$file"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://jitsi.org/;
    description = "Open Source Video Calls and Chat";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ khumba ndowens ];
  };
}
