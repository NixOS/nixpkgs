{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "gfshare";
  version = "2.0.0";

  src = fetchgit {
    url = "git://git.gitano.org.uk/libgfshare.git";
    rev = version;
    sha256 = "0s37xn9pr5p820hd40489xwra7kg3gzqrxhc2j9rnxnd489hl0pr";
  };

  nativeBuildInputs = [ autoreconfHook ];
  doCheck = true;

  outputs = [
    "bin"
    "lib"
    "dev"
    "out"
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # Not the most descriptive homepage but it's what Debian and Ubuntu use
    # https://packages.debian.org/sid/libgfshare2
    # https://launchpad.net/ubuntu/impish/+source/libgfshare/+copyright
    homepage = "https://git.gitano.org.uk/libgfshare.git/";
    description = "Shamir's secret-sharing method in the Galois Field GF(2**8)";
<<<<<<< HEAD
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.rraval ];
=======
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.rraval ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/gfshare.x86_64-darwin
  };
}
