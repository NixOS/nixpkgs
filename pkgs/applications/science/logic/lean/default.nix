{ lib, stdenv, fetchFromGitHub, cmake, gmp, coreutils }:

stdenv.mkDerivation rec {
  pname = "lean";
  version = "3.43.0";

  src = fetchFromGitHub {
    owner  = "leanprover-community";
    repo   = "lean";
    # lean's version string contains the commit sha1 it was built
    # from. this is then used to check whether an olean file should be
    # rebuilt. don't use a tag as rev because this will get replaced into
    # src/githash.h.in in preConfigure.
    rev    = "bfce34363b0efe86e93e3fe75de76ab3740c772d";
    sha256 = "100mb003zkgrv1wd2agbk41aipk3j78k8zcjbj7pv9ixh02c7ss8";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gmp ];

  cmakeDir = "../src";

  # Running the tests is required to build the *.olean files for the core
  # library.
  doCheck = true;

  preConfigure = assert builtins.stringLength src.rev == 40; ''
     substituteInPlace src/githash.h.in \
       --subst-var-by GIT_SHA1 "${src.rev}"
     substituteInPlace library/init/version.lean.in \
       --subst-var-by GIT_SHA1 "${src.rev}"
  '';

  postPatch = "patchShebangs .";

  postInstall = lib.optionalString stdenv.isDarwin ''
    substituteInPlace $out/bin/leanpkg \
      --replace "greadlink" "${coreutils}/bin/readlink"
  '';

  meta = with lib; {
    description = "Automatic and interactive theorem prover";
    homepage    = "https://leanprover.github.io/";
    changelog   = "https://github.com/leanprover-community/lean/blob/v${version}/doc/changes.md";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice gebner ];
  };
}

