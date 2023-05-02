{ lib
, stdenv
, removeReferencesTo
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
}:

stdenv.mkDerivation rec {
  pname = "prrte";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "openpmix";
    repo = "prrte";
    rev = "v${version}";
    sha256 = "sha256-RDxd4veLGbN+T7xCDnNp2lbOM7mwKKD+SKdPmExr1C8=";
    fetchSubmodules = true;
  };

  outputs = [ "out" "dev" ];

  postPatch = ''
    patchShebangs ./autogen.pl
    patchShebangs ./config
  '';

  preConfigure = ''
    ./autogen.pl
  '';

  postInstall = ''
    moveToOutput "bin/prte_info" "''${!outputDev}"
    moveToOutput "bin/pcc" "''${!outputDev}"

    remove-references-to -t $dev $(readlink -f $out/lib/libprrte${stdenv.hostPlatform.extensions.library})
  '';

  nativeBuildInputs = [ removeReferencesTo perl python3 autoconf automake libtool flex gitMinimal ];

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
