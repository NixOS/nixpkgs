{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2gui }:
stdenv.mkDerivation rec {
  name = "MBdistortion-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "MBdistortion";
    rev = "v${version}";
    sha256 = "1rmvfi48hg8ybfw517zgj3fjj2xzckrmv8x131i26vj0fv7svjsp";
  };

  buildInputs = [ faust2jaqt faust2lv2gui ];

  buildPhase = ''
    faust2jaqt -t 99999 MBdistortion.dsp
    faust2lv2 -gui -t 99999 MBdistortion.dsp
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
