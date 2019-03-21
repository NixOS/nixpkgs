{ stdenv, fetchFromGitHub, autoconf, gperf, flex, bison }:

stdenv.mkDerivation rec {
  name = "iverilog-${version}";
  version = "2018.12.15";

  src = fetchFromGitHub {
    owner = "steveicarus";
    repo = "iverilog";
    rev = "7cd078e7ab184069b3b458fe6df7e83962254816";
    sha256 = "1zc7lsa77dbsxjfz7vdgclmg97r0kw08xss7yfs4vyv5v5gnn98d";
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
