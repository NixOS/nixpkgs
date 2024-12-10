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
    repo = pname;
    rev = version;
    hash = "sha256-PyCR/ob947W+6T56y1se74aNy1avJDb2ELyv2aGf1og=";
  };

  cargoHash = "sha256-/a1SjGDcauOy1vmXvmWBZmag8G+T2au+Z7b0y1Vj3C8=";

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
    description = "A lightweight application launcher for X11";
    homepage = "https://github.com/PonasKovas/rlaunch";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ danc86 ];
    mainProgram = "rlaunch";
  };
}
