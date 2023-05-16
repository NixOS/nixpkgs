{ lib, stdenv, fetchFromGitHub, cmake, gmp, coreutils }:

stdenv.mkDerivation rec {
  pname = "lean";
<<<<<<< HEAD
  version = "3.51.0";
=======
  version = "3.50.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner  = "leanprover-community";
    repo   = "lean";
    # lean's version string contains the commit sha1 it was built
    # from. this is then used to check whether an olean file should be
    # rebuilt. don't use a tag as rev because this will get replaced into
    # src/githash.h.in in preConfigure.
<<<<<<< HEAD
    rev    = "9fc1dee97a72a3e34d658aefb4b8a95ecd3d477c";
    hash   = "sha256-Vcsph4dTNLafeaTtVwJS8tWoWCgcP6pxF0ssZDE/YfM=";
=======
    rev    = "855e5b74e3a52a40552e8f067169d747d48743fd";
    sha256 = "sha256-RH4w7PpzC+fhqCHikXQO2pUUvWD2qrA0mVMUGxpauwE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

