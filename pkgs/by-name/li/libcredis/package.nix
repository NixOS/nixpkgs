{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libcredis";
  version = "0.2.3";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/credis/credis-${version}.tar.gz";
    sha256 = "1l3hlw9rrc11qggbg9a2303p3bhxxx2vqkmlk8avsrbqw15r1ayr";
  };

  # credis build system has no install actions, provide our own.
  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"
    mkdir -p "$out/include"

    cp -v credis-test "$out/bin/"
    cp -v *.a *.so "$out/lib/"
    cp -v *.h "$out/include/"
  '';

  meta = with lib; {
    description = "C client library for Redis (key-value database)";
    mainProgram = "credis-test";
    homepage = "https://code.google.com/archive/p/credis/";
    license = licenses.bsd3; # from homepage
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
