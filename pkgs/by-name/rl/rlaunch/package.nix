{
  lib,
  fetchFromGitHub,
  rustPlatform,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "rlaunch";
  version = "1.3.14";

  src = fetchFromGitHub {
    owner = "PonasKovas";
    repo = "rlaunch";
    rev = version;
    hash = "sha256-PyCR/ob947W+6T56y1se74aNy1avJDb2ELyv2aGf1og=";
  };

  cargoHash = "sha256-5mj20MN0FUNa2xawocNhh2C1jX0yN2QNnKYvJi88b0M=";

  # The x11_dl crate dlopen()s these libraries, so we have to inject them into rpath.
  postFixup = ''
    patchelf --set-rpath ${
      lib.makeLibraryPath (
        with xorg;
        [
          libX11
          libXft
          libXinerama
        ]
      )
    } $out/bin/rlaunch
  '';

  meta = with lib; {
    description = "Lightweight application launcher for X11";
    homepage = "https://github.com/PonasKovas/rlaunch";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ danc86 ];
    mainProgram = "rlaunch";
  };
}
