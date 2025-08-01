{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "adbtuifm";
  version = "0.5.8";
  src = fetchFromGitHub {
    owner = "darkhz";
    repo = "adbtuifm";
    tag = "v${version}";
    hash = "sha256-TK93O9XwMrsrQT3EG0969HYMtYkK0a4PzG9FSTqHxAY=";
  };
  vendorHash = "sha256-voVoowjM90OGWXF4REEevO8XEzT7azRYiDay4bnGBks=";
  meta = {
    description = "TUI-based file manager for the Android Debug Bridge";
    homepage = "https://github.com/darkhz/adbtuifm";
    changelog = "https://github.com/darkhz/adbtuifm/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "adbtuifm";
    platforms = lib.platforms.linux;
  };
}
