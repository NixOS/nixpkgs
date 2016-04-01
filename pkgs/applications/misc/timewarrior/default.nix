{ stdenv, fetchgit, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  name = "timewarrior-${version}";
  version = "2016-03-29";

  enableParallelBuilding = true;

  src = fetchgit {
    url = "https://git.tasktools.org/scm/tm/timew.git";
    rev = "2175849a81ddd03707dca7b4c9d69d8fa11e35f7";
    sha256 = "1c55a5jsm9n2zcyskklhqiclnlb2pz2h7klbzx481nsn62xd6bbg";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A command-line time tracker";
    homepage = http://tasktools.org/projects/timewarrior.html;
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux;
  };
}

