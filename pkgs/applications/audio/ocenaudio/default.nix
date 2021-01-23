{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, dpkg
, qt5
, libjack2
, alsaLib
, bzip2
, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "ocenaudio";
  version = "3.9.6";

  src = fetchurl {
    url = "https://www.ocenaudio.com/downloads/index.php/ocenaudio_debian9_64.deb?version=${version}";
    sha256 = "07r49133kk99ya4grwby3admy892mkk9cfxz3wh0v81aznhpw4jg";
  };


  nativeBuildInputs = [
    autoPatchelfHook
    qt5.qtbase
    libjack2
    libpulseaudio
    bzip2
    alsaLib
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
    ln -s ${bzip2.out}/lib/libbz2.so.1 $out/libbz2.so.1.0
  '';

  meta = with lib; {
    description = "Cross-platform, easy to use, fast and functional audio editor";
    homepage = "https://www.ocenaudio.com";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
