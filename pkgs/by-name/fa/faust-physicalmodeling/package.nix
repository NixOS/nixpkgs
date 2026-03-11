{
  stdenv,
  lib,
  bash,
  fetchFromGitHub,
  faust2jaqt,
  faust2lv2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "faust-physicalmodeling";
  version = "2.83.1";

  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faust";
    rev = finalAttrs.version;
    sha256 = "sha256-c1I5ha9QvnC7jKdycAhW/iAzUcEA7NopXAquIS001Y8=";
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

  meta = {
    description = "Physical models included with faust compiled as jack standalone and lv2 instruments";
    homepage = "https://github.com/grame-cncm/faust/tree/master-dev/examples/physicalModeling";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ magnetophon ];
    # compiles stuff for the build platform, difficult to do properly
    broken = stdenv.hostPlatform != stdenv.buildPlatform;
  };
})
