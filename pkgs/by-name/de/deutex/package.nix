{
  stdenv,
  lib,
  autoreconfHook,
  fetchFromGitHub,
  pkg-config,
  libpng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deutex";
  version = "5.2.3";

  src = fetchFromGitHub {
    owner = "Doom-Utils";
    repo = "deutex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wDAlwOtupkYv6y4fQPwL/PVOhh7wqORnjxV22kmON+U=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInput = [
    libpng
  ];

  meta = {
    description = "Command-line tool to create and modify WAD files for games built on the original Doom engine";
    homepage = "https://github.com/Doom-Utils/deutex";
    license = with lib.licenses; [
      gpl2Plus
      hpnd
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ thetaoofsu ];
    mainProgram = "deutex";
    platforms = lib.platforms.unix;
  };
})
