{
  stdenv,
  lib,
  bash,
  fetchFromGitHub,
  faust2jaqt,
  faust2lv2,
}:
stdenv.mkDerivation rec {
  pname = "faustPhysicalModeling";
  version = "2.79.3";

  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faust";
    rev = version;
    sha256 = "sha256-j5ADlKZriwLARpEJ/4xgvyAhF5ld9Hl2gXZS3NPJJj8=";
  };

  nativeBuildInputs = [
    faust2jaqt
    faust2lv2
  ];

  buildInputs = [
    bash
  ];

  dontWrapQtApps = true;

  buildPhase = ''
    runHook preBuild

    cd examples/physicalModeling

    for f in *MIDI.dsp; do
      faust2jaqt -time -vec -double -midi -nvoices 16 -t 99999 $f
      faust2lv2  -time -vec -double -gui -nvoices 16 -t 99999 $f
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/lv2 $out/bin
    mv *.lv2/ $out/lib/lv2
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
    patchShebangs --host $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Physical models included with faust compiled as jack standalone and lv2 instruments";
    homepage = "https://github.com/grame-cncm/faust/tree/master-dev/examples/physicalModeling";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ magnetophon ];
    # compiles stuff for the build platform, difficult to do properly
    broken = stdenv.hostPlatform != stdenv.buildPlatform;
  };
}
