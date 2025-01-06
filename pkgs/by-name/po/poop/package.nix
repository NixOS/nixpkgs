{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
}:

stdenv.mkDerivation rec {
  pname = "poop";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "poop";
    rev = version;
    hash = "sha256-zrqR/TTELhsBIX42PysFsHPRs8Lx/zHcmi+VMDw1SdQ=";
  };

  nativeBuildInputs = [
    zig.hook
  ];

  meta = {
    description = "Compare the performance of multiple commands with a colorful terminal user interface";
    homepage = "https://github.com/andrewrk/poop";
    changelog = "https://github.com/andrewrk/poop/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    platforms = lib.platforms.linux;
    mainProgram = "poop";
  };
}
