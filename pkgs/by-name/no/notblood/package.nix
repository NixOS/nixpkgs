{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "notblood";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "clipmove";
    repo = "NotBlood";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+e7019a60afc17898f55ad781d619e562173e7fc7=";
    fetchSubmodules = true;
  };

  buildInputs = [ SDL2 ];
  nativeBuildInputs = [
    cmake
    perl
    libflac
  ];

  installPhase = ''
    install -Dm755 notblood $out/bin/notblood
  '';

  meta = {
    homepage = "https://github.com/clipmove/NotBlood";
    description = "Gameplay Mod of NBlood";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fluddsskark ];
    mainProgram = "notblood";
  };
})
