{ stdenv, fetchFromGitHub, autoconf, gperf, flex, bison }:

stdenv.mkDerivation rec {
  name = "iverilog-${version}";
  version = "2016.05.21";

  src = fetchFromGitHub {
    owner = "steveicarus";
    repo = "iverilog";
    rev = "45fbf558065c0fdac9aa088ecd34e9bf49e81305";
    sha256 = "137p7gkmp5kwih93i2a3lcf36a6k38j7fxglvw9y59w0233vj452";
  };

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
