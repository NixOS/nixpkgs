{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dethrace";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "dethrace-labs";
    repo = "dethrace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+C3NyRLmvXrkZuhLGwIIHFWjXLMpt3srLZCVrxRUlkA=";
    fetchSubmodules = true;
  };

  buildInputs = [ SDL2 ];
  nativeBuildInputs = [
    cmake
    perl
  ];

  installPhase = ''
    install -Dm755 dethrace $out/bin/dethrace
  '';

  meta = {
    homepage = "https://twitter.com/dethrace_labs";
    description = "Reverse engineering the 1997 game Carmageddon";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ astro ];
    mainProgram = "dethrace";
  };
})
