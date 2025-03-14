{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  faust2jaqt,
  faust2lv2,
}:
stdenv.mkDerivation rec {
  pname = "MBdistortion";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "MBdistortion";
    rev = "V${version}";
    sha256 = "0mdzaqmxzgspfgx9w1hdip18y17hwpdcgjyq1rrfm843vkascwip";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/magnetophon/MBdistortion/commit/10e35084b88c559f1b63760cf40fd5ef5a6745a5.patch";
      sha256 = "0hwjl3rzvn3id0sr0qs8f37jdmr915mdan8miaf78ra0ir3wnk76";
    })
  ];

  buildInputs = [
    faust2jaqt
    faust2lv2
  ];

  dontWrapQtApps = true;

  buildPhase = ''
    faust2jaqt -time -vec -t 99999 MBdistortion.dsp
    faust2lv2 -time -vec -gui -t 99999 MBdistortion.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
    mkdir -p $out/lib/lv2
    cp -r MBdistortion.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "Mid-side multiband distortion for jack and lv2";
    homepage = "https://github.com/magnetophon/MBdistortion";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
