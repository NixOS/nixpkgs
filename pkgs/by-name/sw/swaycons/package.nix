{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "swaycons";
  version = "unstable-2023-11-29";

  src = fetchFromGitHub {
    owner = "allie-wake-up";
    repo = "swaycons";
    rev = "aa1102393be34e8bd7ed4e74c574e851fbd8cff9";
    hash = "sha256-vyZcfBH2mry8Yd41QPX4+yLv0nS9J1yrgg7lpslJs7M=";
  };

  cargoHash = "sha256-LE+YEFmkB4EBQcuxbExN9Td5LWpI4AZgyVHXdTyq7gU=";

  meta = {
    description = "Window Icons in Sway with Nerd Fonts";
    mainProgram = "swaycons";
    homepage = "https://github.com/allie-wake-up/swaycons";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aacebedo ];
  };
}
