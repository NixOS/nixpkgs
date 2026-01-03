{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  makeWrapper,
}:
stdenv.mkDerivation {
  pname = "exodus";
  version = "unstable-2025-03-31";
  src = fetchFromGitHub {
    owner = "nrootconauto";
    repo = "EXODUS";
    rev = "6d806dd5ae5507858c03c4d13be1f3d37a06fa4b";
    hash = "sha256-EmIoJj5IjLy0dvuBQR46Oi/xgkbqv/IT+cJa59/aaWI=";
  };
  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [ SDL2 ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -a ../exodus $out/bin
    runHook postInstall
  '';
  # tell the EXODUS program where the TempleOS root and bootstrap is
  postFixup = ''
    wrapProgram $out/bin/exodus \
      --add-flags "--root=$src/T --hcrtfile=$src/HCRT_BOOTSTRAP.BIN"
  '';
  meta = with lib; {
    description = "EXODUS - A TempleOS emulator";
    homepage = "https://github.com/nrootconauto/EXODUS";
    license = licenses.zlib;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.unix;
  };
}
