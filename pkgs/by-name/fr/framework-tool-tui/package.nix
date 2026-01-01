{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "framework-tool-tui";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.5.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "grouzen";
    repo = "framework-tool-tui";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-6JfxKoH6omqg46Y7zDIj4xQOzTGP36OW2nOS4fTsy7A=";
  };

  cargoHash = "sha256-YsmGYsCLlucFq/Xg+VSrqh1tKev8T+xDEL8B2jUwH/A=";
=======
    hash = "sha256-6rphmprOTg+Zk3HbE6mdszmQsCQ8mUbs59rvLeKQkps=";
  };

  cargoHash = "sha256-0/6b0C+uUNz03r5IEBvAGzagSyjzXFVbE74rgfGJoyM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
