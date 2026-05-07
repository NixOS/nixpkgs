{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyx";
  version = "2024.02.29";

  src = fetchurl {
    url = "https://yx7.cc/code/hyx/hyx-${lib.replaceStrings [ "-" ] [ "." ] finalAttrs.version}.tar.xz";
    sha256 = "sha256-dufx3zsabeet7Rp0d60MIuNqisIQd6UgE7WDZYNHl3E=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile \
      --replace "-Wl,-z,relro,-z,now -fpic -pie" ""
  '';

  installPhase = ''
    install -vD hyx $out/bin/hyx
  '';

  meta = {
    description = "Minimalistic but powerful Linux console hex editor";
    mainProgram = "hyx";
    homepage = "https://yx7.cc/code/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
