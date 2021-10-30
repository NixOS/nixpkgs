{ stdenv
, dpkg
, lib
, autoPatchelfHook
, fetchurl
, webkitgtk
, libjack2
, alsa-lib
, curl
}:

stdenv.mkDerivation rec {
  pname = "tonelib-zoom";
  version = "4.3.1";

  src = fetchurl {
    url = "https://www.tonelib.net/download/0129/ToneLib-Zoom-amd64.deb";
    sha256 = "sha256-4q2vM0/q7o/FracnO2xxnr27opqfVQoN7fsqTD9Tr/c=";
  };

  buildInputs = [
    dpkg
    webkitgtk
    libjack2
    alsa-lib
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  unpackPhase = ''
    mkdir -p $TMP/ $out/
    dpkg -x $src $TMP
  '';

  installPhase = ''
    cp -R $TMP/usr/* $out/
    mv $out/bin/ToneLib-Zoom $out/bin/tonelib-zoom
  '';

  runtimeDependencies = [
    (lib.getLib curl)
  ];

  meta = with lib; {
    description = "ToneLib Zoom – change and save all the settings in your Zoom(r) guitar pedal";
    homepage = "https://tonelib.net/";
    license = licenses.unfree;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
