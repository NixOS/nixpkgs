{
  lib,
  stdenv,
  fetchFromGitHub,

  SDL2,

  libX11,
  libXext,

  guiBackend ? "sdl",

  enableSDL ? guiBackend == "sdl",
  enableX11 ? guiBackend == "x11",
}:

assert lib.assertMsg (builtins.elem guiBackend [
  "sdl"
  "x11"
  "none"
]) "Unsupported GUI backend";
assert lib.assertMsg (!(enableSDL && enableX11)) "RVVM can have only one GUI backend at a time";
assert lib.assertMsg (
  stdenv.hostPlatform.isDarwin -> !enableX11
) "macOS supports only SDL GUI backend";

stdenv.mkDerivation rec {
  pname = "rvvm";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "LekKit";
    repo = "RVVM";
    rev = "v${version}";
    sha256 = "sha256-5nSlKyWDAx0EeKFzzwP5+99XuJz9BHXEF1WNkRMLa9U=";
  };

  buildInputs =
    [ ]
    ++ lib.optionals enableSDL [ SDL2 ]
    ++ lib.optionals enableX11 [
      libX11
      libXext
    ];

  enableParallelBuilding = true;

  buildFlags = [
    "all"
    "lib"
  ];

  makeFlags =
    [ "PREFIX=$(out)" ]
    ++ lib.optional enableSDL "USE_SDL=2" # Use SDL2 instead of SDL1
    ++ lib.optional (!enableSDL && !enableX11) "USE_FB=0";

  meta = with lib; {
    homepage = "https://github.com/LekKit/RVVM";
    description = "RISC-V Virtual Machine";
    license = with licenses; [
      gpl3 # or
      mpl20
    ];
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ kamillaova ];
    mainProgram = "rvvm";
  };
}
