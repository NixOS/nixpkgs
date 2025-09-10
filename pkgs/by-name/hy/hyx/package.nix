{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "hyx";
  version = "2024.02.29";

  src = fetchurl {
    url = "https://yx7.cc/code/hyx/hyx-${lib.replaceStrings [ "-" ] [ "." ] version}.tar.xz";
    sha256 = "sha256-dufx3zsabeet7Rp0d60MIuNqisIQd6UgE7WDZYNHl3E=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile \
      --replace "-Wl,-z,relro,-z,now -fpic -pie" ""
  '';

  installPhase = ''
    install -vD hyx $out/bin/hyx
  '';

  meta = with lib; {
    description = "Minimalistic but powerful Linux console hex editor";
    mainProgram = "hyx";
    homepage = "https://yx7.cc/code/";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    platforms = with platforms; linux ++ darwin;
  };
}
