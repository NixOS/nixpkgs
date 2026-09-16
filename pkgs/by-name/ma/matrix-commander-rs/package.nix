{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  perl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matrix-commander-rs";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eWD1nj+xRWNkyC3lM/hIZACI2i1Awl9NTgslR8rJZSc=";
  };

  cargoHash = "sha256-OWuKwaJfwOAtwtN0so/afWeHq2oslAT2YahnJC0QB6w=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(0.*)$" # https://github.com/8go/matrix-commander-rs/issues/194#issuecomment-4864773450
    ];
  };

  meta = {
    description = "CLI-based Matrix client app for sending and receiving";
    homepage = "https://github.com/8go/matrix-commander-rs";
    changelog = "https://github.com/8go/matrix-commander-rs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fab
      ilkecan
    ];
    mainProgram = "matrix-commander-rs";
  };
})
