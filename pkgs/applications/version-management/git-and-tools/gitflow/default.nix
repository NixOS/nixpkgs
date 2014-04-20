{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gitflow-${version}";
  version = "1.7.0";

  src = fetchurl {
    url = "https://github.com/petervanderdoes/gitflow/archive/${version}.tar.gz";
    sha256 = "0rppgyqgk0drip6852bdm2479zks16cb3mj1jdw6jq80givrqnjx";
  };

  preBuild = ''
    makeFlagsArray+=(prefix="$out")
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/petervanderdoes/gitflow;
    description = "A collection of Git extensions to provide high-level repository operations for Vincent Driessen's branching model";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.offline ];
  };
}
