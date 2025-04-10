{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_12,
}:

stdenv.mkDerivation rec {
  pname = "cyber";
  version = "0-unstable-2025-12-10";

  src = fetchFromGitHub {
    owner = "fubark";
    repo = "cyber";
    rev = "2a2298d6aa12f9136b18cd85965f4a58e484f506";
    hash = "sha256-d81z+wUIQ/KUVa+GyXbT+E8dsG8Mdt1hZW1Qe1mmAiw=";
  };

  nativeBuildInputs = [
    zig_0_12.hook
  ];

  zigBuildFlags = [
    "cli"
  ];

  env = {
    COMMIT = lib.substring 0 7 src.rev;
  };

  meta = with lib; {
    description = "Fast, efficient, and concurrent scripting language";
    mainProgram = "cyber";
    homepage = "https://github.com/fubark/cyber";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    inherit (zig_0_12.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
