{stdenv, fetchFromGitHub, flex, bison, cmake, git, zlib}:

stdenv.mkDerivation rec {

  version = "2017-01-12";
  name = "pbrt-v3-${version}";

  src = fetchFromGitHub {
    rev = "35b6da3429526f2026fe5e5ebaf36d593e113028";
    owner  = "mmp";
    repo   = "pbrt-v3";
    sha256 = "10lvbph13p6ilzqb8sgrvn9gg1zmi8wpy3hhjbqp8dnsa4x0mhj7";
    fetchSubmodules = true;
  };

  buildInputs = [ git flex bison cmake zlib ];

  meta = with stdenv.lib; {
    homepage = http://pbrt.org;
    description = "The renderer described in the third edition of the book 'Physically Based Rendering: From Theory To Implementation'";
    platforms = platforms.linux ;
    license = licenses.bsd2;
    maintainers = [ maintainers.juliendehos ];
    priority = 10;
  };
}
