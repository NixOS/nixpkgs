{ stdenv, fetchFromGitHub, autoconf, gperf, flex, bison }:

stdenv.mkDerivation rec {
  name = "iverilog-${version}";
  version = "2017.08.12";

  src = fetchFromGitHub {
    owner = "steveicarus";
    repo = "iverilog";
    rev = "ac87138c44cd6089046668c59a328b4d14c16ddc";
    sha256 = "1npv0533h0h2wxrxkgiaxqiasw2p4kj2vv5bd69w5xld227xcwpg";
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
