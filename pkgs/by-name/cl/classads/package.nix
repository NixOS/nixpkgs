{ lib, stdenv, fetchurl, autoreconfHook, pcre }:

stdenv.mkDerivation rec {
  pname = "classads";
  version = "1.0.10";

  src = fetchurl {
    url = "ftp://ftp.cs.wisc.edu/condor/classad/c++/classads-${version}.tar.gz";
    sha256 = "1czgj53gnfkq3ncwlsrwnr4y91wgz35sbicgkp4npfrajqizxqnd";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ pcre ];

  configureFlags = [
    "--enable-namespace" "--enable-flexible-member"
  ];

  # error: use of undeclared identifier 'finite'; did you mean 'isfinite'?
  env.NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) "-Dfinite=isfinite";

  meta = {
    homepage = "http://www.cs.wisc.edu/condor/classad/";
    description = "Classified Advertisements library provides a generic means for matching resources";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
