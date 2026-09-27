{
  lib,
  stdenv,
  fetchurl,
  doxygen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblo";
  version = "0.36";

  src = fetchurl {
    url = "mirror://sourceforge/liblo/liblo/${finalAttrs.version}/liblo-${finalAttrs.version}.tar.gz";
    hash = "sha256-wI0Ugy6Nz48GhAQFgkpPlhGgyz2u0BmJRjJsdAlByLY=";
  };

  nativeBuildInputs = [
    doxygen
  ];

  doCheck = false; # fails 1 out of 3 tests

  meta = {
    changelog = "https://liblo.sourceforge.net/NEWS.html";
    description = "Lightweight library to handle the sending and receiving of messages according to the Open Sound Control (OSC) protocol";
    homepage = "https://sourceforge.net/projects/liblo";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
