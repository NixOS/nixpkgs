{
  lib,
  stdenv,
  fetchFromGitHub,

  SDL2,

  libx11,
  libxext,

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

stdenv.mkDerivation (finalAttrs: {
  pname = "rvvm";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "LekKit";
    repo = "RVVM";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5nSlKyWDAx0EeKFzzwP5+99XuJz9BHXEF1WNkRMLa9U=";
  };

  buildInputs =
    [ ]
    ++ lib.optionals enableSDL [ SDL2 ]
    ++ lib.optionals enableX11 [
      libx11
      libxext
    ];

  enableParallelBuilding = true;

  buildFlags = [
    "all"
    "lib"
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ]
  ++ lib.optional enableSDL "USE_SDL=2" # Use SDL2 instead of SDL1
  ++ lib.optional (!enableSDL && !enableX11) "USE_FB=0";

  meta = {
    homepage = "https://github.com/LekKit/RVVM";
    description = "RISC-V Virtual Machine";
    license = with lib.licenses; [
      gpl3 # or
      mpl20
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ kamillaova ];
    mainProgram = "rvvm";
  };
})
