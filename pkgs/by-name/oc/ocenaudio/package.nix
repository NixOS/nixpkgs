{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, dpkg
, qt5
, libjack2
, alsa-lib
, bzip2
, libpulseaudio
, xz
}:

stdenv.mkDerivation rec {
  pname = "ocenaudio";
  version = "3.13.3";

  src = fetchurl {
    url = "https://www.ocenaudio.com/downloads/index.php/ocenaudio_debian9_64.deb?version=${version}";
    hash = "sha256-B0+NyFZ9c0ljzYMJm3741TpoxFS0Zo6hxzhadYFofSA=";
  };

  nativeBuildInputs = [
    alsa-lib
    autoPatchelfHook
    bzip2
    libjack2
    libpulseaudio
    qt5.qtbase
    qt5.wrapQtAppsHook
    xz
  ];

  buildInputs = [ dpkg ];

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    cp -av $out/opt/ocenaudio/* $out
    rm -rf $out/opt

    # Create symlink bzip2 library
    ln -s ${bzip2.out}/lib/libbz2.so.1 $out/lib/libbz2.so.1.0
  '';

  meta = with lib; {
    description = "Cross-platform, easy to use, fast and functional audio editor";
    homepage = "https://www.ocenaudio.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ onny ];
  };
}
