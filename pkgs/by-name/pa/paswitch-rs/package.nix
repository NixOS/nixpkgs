{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pulseaudio,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "paswitch-rs";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "RobertPlant";
    repo = "paswitch-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1XTYOky2IHb0queK6Kd2hmCmvLSrLb7Fyq5ljNmr9Hk=";
  };

  cargoHash = "sha256-xP9mP+KzsGOGyl07RG9pHDYPUeCIBNgZmvZRlYQFWMo=";

  __structuredAttrs = true;

  # pactl is called at runtime; bake in the store path instead of trusting $PATH.
  postPatch = ''
    substituteInPlace src/commands.rs \
      --replace-fail '"pactl"' '"${lib.getExe' pulseaudio "pactl"}"'
  '';

  meta = {
    description = "List and swap to pulse sinks by name";
    homepage = "https://github.com/RobertPlant/paswitch-rs";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ robertplant ];
    mainProgram = "paswitch-rs";
    platforms = lib.platforms.linux;
  };
})
