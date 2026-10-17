{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmd";
  version = "1.3.0";

  src = fetchurl {
    urls = [
      "https://archive.hadrons.org/software/libmd/libmd-${finalAttrs.version}.tar.xz"
      "https://libbsd.freedesktop.org/releases/libmd-${finalAttrs.version}.tar.xz"
    ];
    hash = "sha256-/A8etrZ2ZHAybywBRpOAkZDmfbqEJ0pvuunUkS0GZwY=";
  };

  enableParallelBuilding = true;

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook ];

  strictDeps = true;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  __structuredAttrs = true;

  meta = {
    homepage = "https://www.hadrons.org/software/libmd/";
    changelog = "https://archive.hadrons.org/software/libmd/libmd-${finalAttrs.version}.announce";
    # Git: https://git.hadrons.org/cgit/libmd.git
    description = "Message Digest functions from BSD systems";
    license = with lib.licenses; [
      bsd3
      bsd2
      isc
      beerware
      publicDomain
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
