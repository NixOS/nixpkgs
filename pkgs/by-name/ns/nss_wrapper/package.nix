{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "nss_wrapper";
  version = "1.1.16";

  src = fetchurl {
    url = "mirror://samba/cwrap/nss_wrapper-${version}.tar.gz";
    sha256 = "sha256-3HmrByd5vkQDtFtgzQRN0TeA1LuWddJ6vxkyrafIqI0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

<<<<<<< HEAD
  meta = {
    description = "Wrapper for the user, group and hosts NSS API";
    mainProgram = "nss_wrapper.pl";
    homepage = "https://git.samba.org/?p=nss_wrapper.git;a=summary;";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Wrapper for the user, group and hosts NSS API";
    mainProgram = "nss_wrapper.pl";
    homepage = "https://git.samba.org/?p=nss_wrapper.git;a=summary;";
    license = licenses.bsd3;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    broken = stdenv.hostPlatform.isDarwin;
  };
}
