{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "resolv_wrapper";
  version = "1.1.8";

  src = fetchurl {
    url = "mirror://samba/cwrap/resolv_wrapper-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-+8MPd9o+EuzU72bM9at34LdEkwzNiQYkBAgvkoqOwuA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = {
    description = "Wrapper for the user, group and hosts NSS API";
    homepage = "https://git.samba.org/?p=uid_wrapper.git;a=summary;";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
