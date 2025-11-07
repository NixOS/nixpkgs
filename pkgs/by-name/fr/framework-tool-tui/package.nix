{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "framework-tool-tui";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "grouzen";
    repo = "framework-tool-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R4/VeymmthI96PJt7XsKRYz1Y8QW/lV90HvJgt+e+hI=";
  };

  cargoHash = "sha256-tDNYkV5MWb4+co/gwjpAt/M7yJbEWrryieJoBuXmY8M=";

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
