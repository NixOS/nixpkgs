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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "dethrace-labs";
    repo = "dethrace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yo5AXLMSEFlWe/BV/At7XL2yJQ9hgcMZfC3hu5KEF8Y=";
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
