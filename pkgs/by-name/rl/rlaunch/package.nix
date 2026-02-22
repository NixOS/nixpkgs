{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxinerama,
  libxft,
  libx11,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rlaunch";
  version = "1.3.14";

  src = fetchFromGitHub {
    owner = "PonasKovas";
    repo = "rlaunch";
    rev = finalAttrs.version;
    hash = "sha256-PyCR/ob947W+6T56y1se74aNy1avJDb2ELyv2aGf1og=";
  };

  cargoHash = "sha256-5mj20MN0FUNa2xawocNhh2C1jX0yN2QNnKYvJi88b0M=";

  # The x11_dl crate dlopen()s these libraries, so we have to inject them into rpath.
  postFixup = ''
    patchelf --set-rpath ${
      lib.makeLibraryPath [
        libx11
        libxft
        libxinerama
      ]
    } $out/bin/rlaunch
  '';

  meta = {
    description = "Lightweight application launcher for X11";
    homepage = "https://github.com/PonasKovas/rlaunch";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ danc86 ];
    mainProgram = "rlaunch";
  };
})
