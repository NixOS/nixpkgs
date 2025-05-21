{
  stdenv,
  lib,
  autoreconfHook,
  fetchFromGitHub,
  pkg-config,
  ...
}:

stdenv.mkDerivation {
  pname = "deutex";
  version = "5.2.3";

  src = fetchFromGitHub {
    owner = "Doom-Utils";
    repo = "deutex";
    tag = "v5.2.3";
    hash = "sha256-wDAlwOtupkYv6y4fQPwL/PVOhh7wqORnjxV22kmON+U=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    description = "Command-line tool to reate and modify WAD files for games built on the original Doom engine";
    homepage = "https://github.com/Doom-Utils/deutex";
    #license = lib.licenses;
    maintainers = with lib.maintainers; [ thetaoofsu ];
    mainProgram = "deutex";
    platforms = lib.platforms.unix;
  };
}
