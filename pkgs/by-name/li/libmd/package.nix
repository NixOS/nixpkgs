{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmd";
  version = "1.1.0";

  src = fetchurl {
    urls = [
      "https://archive.hadrons.org/software/libmd/libmd-${finalAttrs.version}.tar.xz"
      "https://libbsd.freedesktop.org/releases/libmd-${finalAttrs.version}.tar.xz"
    ];
    sha256 = "sha256-G9aqQidTE68xQcfPLluWTosf1IgCXK8vlx9DsAd2szI=";
  };

  enableParallelBuilding = true;

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://www.hadrons.org/software/libmd/";
    changelog = "https://archive.hadrons.org/software/libmd/libmd-${finalAttrs.version}.announce";
    # Git: https://git.hadrons.org/cgit/libmd.git
    description = "Message Digest functions from BSD systems";
<<<<<<< HEAD
    license = with lib.licenses; [
=======
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      bsd3
      bsd2
      isc
      beerware
      publicDomain
    ];
    maintainers = [ ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
