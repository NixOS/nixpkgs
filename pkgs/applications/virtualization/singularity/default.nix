{ stdenv
, fetchFromGitHub
, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "singularity-${version}";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "singularityware";
    repo = "singularity";
    rev = version;
    sha256 = "19g43gfdy5s8y4252474cp39d6ypn5dd37wp0s21fgd13vqy26px";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  meta = with stdenv.lib; {
    homepage = http://singularity.lbl.gov/;
    description = "Designed around the notion of extreme mobility of compute and reproducible science, Singularity enables users to have full control of their operating system environment";
    license = "BSD license with 2 modifications";
    platforms = platforms.linux;
    maintainers = [ maintainers.jbedo ];
  };
}
