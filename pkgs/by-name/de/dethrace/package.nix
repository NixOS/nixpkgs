{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "dethrace";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "dethrace-labs";
    repo = "dethrace";
    tag = "v${version}";
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

  meta = with lib; {
    homepage = "https://twitter.com/dethrace_labs";
    description = "Reverse engineering the 1997 game Carmageddon";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ astro ];
    mainProgram = "dethrace";
  };
}
