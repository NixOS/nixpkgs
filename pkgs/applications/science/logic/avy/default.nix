{ stdenv, fetchgit, cmake, zlib, boost }:

stdenv.mkDerivation rec {
  name = "avy-${version}";
  version = "2017.10.16";

  src = fetchgit {
    url    = "https://bitbucket.org/arieg/extavy";
    rev    = "c75c83379c38d6ea1046d0caee95aef77283ffe3";
    sha256 = "0zcycnypg4q5g710bnkjpycaawmibc092vmyhgfbixkgq9fb5lfh";
    fetchSubmodules = true;
  };

  buildInputs = [ cmake zlib boost.out boost.dev ];
  NIX_CFLAGS_COMPILE = [ "-Wno-narrowing" ];
  patches =
    [ ./0001-no-static-boost-libs.patch
    ];

  installPhase = ''
    mkdir -p $out/bin
    cp avy/src/{avy,avybmc} $out/bin/
  '';

  meta = {
    description = "AIGER model checking for Property Directed Reachability";
    homepage    = https://arieg.bitbucket.io/avy/;
    license     = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
