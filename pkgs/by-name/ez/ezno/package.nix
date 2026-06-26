{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ezno";
  version = "0.0.23";

  src = fetchFromGitHub {
    owner = "kaleidawave";
    repo = "ezno";
    rev = "release/ezno-${finalAttrs.version}";
    hash = "sha256-YS0DgRtCy+RJsPMDBvAxjF4vjxfCb5gmQWP7YPUWbWU=";
  };

  cargoHash = "sha256-7qTaI8nXH86yIXat584WI6AbJVRZ4PBXdnYDebUrpPA=";

  cargoBuildFlags = [
    "--bin"
    "ezno"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "JavaScript compiler and TypeScript checker with a focus on static analysis and runtime performance";
    mainProgram = "ezno";
    homepage = "https://github.com/kaleidawave/ezno";
    changelog = "https://github.com/kaleidawave/ezno/releases/tag/release/ezno-${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
