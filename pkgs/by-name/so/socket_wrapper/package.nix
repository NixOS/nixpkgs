{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "socket_wrapper";
  version = "1.5.2";

  src = fetchurl {
    url = "mirror://samba/cwrap/socket_wrapper-${finalAttrs.version}.tar.gz";
    hash = "sha256-iw9NbCrn9fD0dfA/rVSWytuMtXkUqBFhZZkJLNgwtW4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = {
    description = "Library passing all socket communications through unix sockets";
    homepage = "https://git.samba.org/?p=socket_wrapper.git;a=summary;";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
