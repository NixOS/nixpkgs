{ stdenv, lib, fetchFromGitHub, makeDesktopItem, unzip, ant, jdk8
# Optional, Jitsi still runs without, but you may pass null:
, alsa-lib, dbus, gtk2, libpulseaudio, openssl, xorg
}:

let jdk = jdk8; in
stdenv.mkDerivation rec {
  pname = "jitsi";
  version = "2.11.5633";

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = "jitsi";
    rev = "refs/tags/${lib.versions.patch version}";
    hash = "sha256-CN4o0VfHdoUteI2wyJ2hFJ9UsQ2wWUzcvrLMbR/l36M=";
  };

  patches = [ ./jitsi.patch ];

  jitsiItem = makeDesktopItem {
    name = "Jitsi";
    exec = "jitsi";
    comment = "VoIP and Instant Messaging client";
    desktopName = "Jitsi";
    genericName = "Instant Messaging";
    categories = [ "Chat" ];
  };

  libPath = lib.makeLibraryPath ([
    stdenv.cc.cc  # For libstdc++.
    alsa-lib
    dbus
    gtk2
    libpulseaudio
    openssl
    xorg.libX11
    xorg.libXext
    xorg.libXScrnSaver
    xorg.libXv
  ]);

  nativeBuildInputs = [ unzip ];
  buildInputs = [ ant jdk ];

  buildPhase = "ant make";

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

  meta = with lib; {
    homepage = "https://desktop.jitsi.org/";
    description = "Open Source Video Calls and Chat";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.jitsi.members;
  };
}
