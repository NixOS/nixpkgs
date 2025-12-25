{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "framework-tool-tui";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "grouzen";
    repo = "framework-tool-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6JfxKoH6omqg46Y7zDIj4xQOzTGP36OW2nOS4fTsy7A=";
  };

  cargoHash = "sha256-YsmGYsCLlucFq/Xg+VSrqh1tKev8T+xDEL8B2jUwH/A=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  meta = {
    description = "TUI for controlling and monitoring Framework Computers hardware";
    longDescription = ''
      A snappy TUI dashboard for controlling and monitoring your Framework Laptop hardware —
      charging, privacy, lighting, USB PD ports, and more.
    '';
    homepage = "https://github.com/grouzen/framework-tool-tui";
    changelog = "https://github.com/grouzen/framework-tool-tui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      griffi-gh
      autra
    ];
    mainProgram = "framework-tool-tui";
  };
})
