{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "MBdistortion";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "MBdistortion";
    rev = "V${version}";
    sha256 = "0mdzaqmxzgspfgx9w1hdip18y17hwpdcgjyq1rrfm843vkascwip";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

  buildPhase = ''
    faust2jaqt -time -vec -t 99999 MBdistortion.dsp
    faust2lv2 -time -vec -gui -t 99999 MBdistortion.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp MBdistortion $out/bin/
    mkdir -p $out/lib/lv2
    cp -r MBdistortion.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "Mid-side multiband distortion for jack and lv2";
    homepage = https://github.com/magnetophon/MBdistortion;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
