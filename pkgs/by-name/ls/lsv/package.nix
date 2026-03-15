{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lsv";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "SecretDeveloper";
    repo = "lsv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6FZ6OIbW1s14dmZqZr26ioHcaT2+M4b+gMhobkHnWG0=";
  };

  cargoHash = "sha256-+42n7WSr1Gwf2DmcxzXIgaEussDpwUZI9dzQoGaU0Ps=";

  meta = {
    description = "Configurable command line file browser with preview and key bindings";
    homepage = "https://github.com/SecretDeveloper/lsv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Inarizxc ];
    platforms = lib.platforms.linux;
    mainProgram = "lsv";
  };
})
