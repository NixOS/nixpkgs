{ stdenv, fetchFromGitHub, autoconf, gperf, flex, bison }:

stdenv.mkDerivation rec {
  name = "iverilog-${version}";
  version = "2019.03.27";

  src = fetchFromGitHub {
    owner  = "steveicarus";
    repo   = "iverilog";
    rev    = "a9388a895eb85a9d7f2924b89f839f94e1b6d7c4";
    sha256 = "01d48sy3pzg9x1xpczqrsii2ckrvgnrfj720wiz22jdn90nirhhr";
  };

  enableParallelBuilding = true;

  patchPhase = ''
    chmod +x $PWD/autoconf.sh
    $PWD/autoconf.sh
  '';

  buildInputs = [ autoconf gperf flex bison ];

  meta = {
    description = "Icarus Verilog compiler";
    repositories.git = https://github.com/steveicarus/iverilog.git;
    homepage = http://www.icarus.com;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [winden];
    platforms = with stdenv.lib.platforms; linux;
  };
}
