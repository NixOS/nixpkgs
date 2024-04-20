{
  buildGoModule,
  fetchFromGitHub,
  android-tools,
  lib,
}:
buildGoModule rec {
  pname = "adbtuifm";
  version = "v0.5.8";
  src = fetchFromGitHub {
    owner = "darkhz";
    repo = pname;
    rev = version;
    hash = "sha256-TK93O9XwMrsrQT3EG0969HYMtYkK0a4PzG9FSTqHxAY=";
  };
  vendorHash = "sha256-voVoowjM90OGWXF4REEevO8XEzT7azRYiDay4bnGBks=";
  buildInputs = [
    android-tools
  ];
  meta = with lib; {
    description = "adbtuifm is a TUI-based file manager for the Android Debug Bridge, to make transfers between the device and client easier.";
    homepage = "https://github.com/darkhz/adbtuifm";
    changelog = "https:/github.com/darkhz/adbtuifm/releases/tag/${version}";
    license = with licenses; [mit];
    maintainers = with maintainers; [daru-san];
    mainProgram = "adbtuifm";
    platforms = platforms.linux;
  };
}
