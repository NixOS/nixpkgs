{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  flex,
  bison,
  gperf,
  libxml2,
  perl,
  perlPackages,
  gd,
}:

stdenv.mkDerivation rec {
  version = "2.3.7";
  pname = "adms";

  src = fetchFromGitHub {
    owner = "Qucs";
    repo = "adms";
    rev = "release-${version}";
    sha256 = "0i37c9k6q1iglmzp9736rrgsnx7sw8xn3djqbbjw29zsyl3pf62c";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    flex
    bison
    gperf
    libxml2
    perl
    gd
    perlPackages.XMLLibXML
  ];
  configureFlags = [ "--enable-maintainer-mode" ];

  meta = with lib; {
    description = "automatic device model synthesizer";
    homepage = "https://github.com/Qucs/adms";
    license = licenses.gpl3;
    maintainers = with maintainers; [ disassembler ];
    platforms = with platforms; unix;
  };
}
