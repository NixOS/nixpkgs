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
  version = "3.9.2";

  src = fetchurl {
    url = "https://www.ocenaudio.com/downloads/index.php/ocenaudio_debian9_64.deb?version=${version}";
    sha256 = "1fvpba3dnzb7sm6gp0znbrima02ckfiy2zwb66x1gr05y9a56inv";
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

  meta = with stdenv.lib; {
    description = "Cross-platform, easy to use, fast and functional audio editor";
    homepage = "https://www.ocenaudio.com";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
