{ autoPatchelfHook,
  alsa-lib,
  fetchurl,
  fluidsynth,
  jack2,
  jre,
  lib,
  lilv,
  makeWrapper,
  nixosTests,
  qt5,
  stdenvNoCC,
  suil,
}:

stdenvNoCC.mkDerivation rec {
  pname = "tuxguitar";
  version = "1.6.3";

  src = fetchurl {
    url = "https://github.com/helge17/tuxguitar/releases/download/${version}/tuxguitar-${version}-linux-swt-amd64.tar.gz";
    hash = "sha256-eO2U6FFTOz2sR/ZN2Amui2DsWMGcfFkFJ3Lhgzyr6aM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    fluidsynth
    jack2
    lilv
    qt5.qtbase
    suil
  ];

  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/tuxguitar

    cp -r * $out/share/tuxguitar

    makeWrapper $out/share/tuxguitar/tuxguitar.sh $out/bin/tuxguitar \
      --prefix PATH : ${lib.makeBinPath [ jre ]}
  '';

  passthru.tests = { inherit (nixosTests) tuxguitar; };

  meta = with lib; {
    description = "Multitrack guitar tablature editor";
    longDescription = ''
      TuxGuitar is a multitrack guitar tablature editor and player written
      in Java-SWT. It can open GuitarPro, PowerTab and TablEdit files.
    '';
    homepage = "https://github.com/helge17/tuxguitar";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.lgpl2;
    maintainers = [ maintainers.ardumont ];
    platforms = platforms.linux;
  };
}
