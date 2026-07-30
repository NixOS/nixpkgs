{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nss_wrapper";
  version = "1.1.16";

  src = fetchurl {
    url = "mirror://samba/cwrap/nss_wrapper-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-3HmrByd5vkQDtFtgzQRN0TeA1LuWddJ6vxkyrafIqI0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = {
    description = "Wrapper for the user, group and hosts NSS API";
    mainProgram = "nss_wrapper.pl";
    homepage = "https://git.samba.org/?p=nss_wrapper.git;a=summary;";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
