{ stdenv, fetchFromGitHub, autoreconfHook, flex, bison, gperf,
  libxml2, perl, perlPackages, gd }:

stdenv.mkDerivation rec {
  version = "2.3.6";
  pname = "adms";

  src = fetchFromGitHub {
    owner = "Qucs";
    repo = "adms";
    rev = "release-${version}";
    sha256 = "1pcwq5khzdq4x33lid9hq967gv78dr5i4f2sk8m8rwkfqb9vdzrg";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ flex bison gperf libxml2 perl gd perlPackages.XMLLibXML ];
  configureFlags = [ "--enable-maintainer-mode" ];

  meta = {
    description = "automatic device model synthesizer";
    homepage = "https://github.com/Qucs/adms";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [disassembler];
    platforms = with stdenv.lib.platforms; linux;
  };
}
