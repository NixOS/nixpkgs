{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gitflow-${version}";
  version = "1.6.1";

  src = fetchurl {
    url = "https://github.com/petervanderdoes/gitflow/archive/${version}.tar.gz";
    sha256 = "1f4879ahi8diddn7qvhr0dkj96gh527xnfihbf1ha83fn9cvvcls";
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
