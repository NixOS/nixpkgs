{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, gitMinimal
, perl
, python3
, flex
, hwloc
, libevent
, zlib
, pmix
,
}:

stdenv.mkDerivation rec {
  pname = "prrte";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "openpmix";
    repo = "prrte";
    rev = "v${version}";
    sha256 = "sha256-WjK26jbte1iYngEfjVfwGXIMhU5aDhmWwUl/fYPrmfw=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs ./autogen.pl
    patchShebangs ./config
  '';

  preConfigure = ''
    ./autogen.pl
  '';

  nativeBuildInputs = [ perl python3 autoconf automake libtool flex gitMinimal ];

  buildInputs = [ libevent hwloc zlib pmix ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "PMIx Reference Runtime Environment";
    homepage = "https://docs.prrte.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
