{
  lib,
  stdenv,
  fetchFromSourcehut,
}:

stdenv.mkDerivation {
  pname = "evhz";
  version = "unstable-2025-10-09";

  src = fetchFromSourcehut {
    owner = "~iank";
    repo = "evhz";
    rev = "189e6c22a9acb01b6eea26659f6944e60f6cb3d8";
    hash = "sha256-p2KH5wpw8PpsICutUnwrKmKPtQ/MauWb+DY55WIJPkE=";
  };

  buildPhase = "gcc -o evhz evhz.c";

  installPhase = ''
    mkdir -p $out/bin
    mv evhz $out/bin
  '';

  meta = {
    description = "Show mouse refresh rate under linux + evdev";
    homepage = "https://git.sr.ht/~iank/evhz";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ Tungsten842 ];
    platforms = lib.platforms.linux;
    mainProgram = "evhz";
  };
}
