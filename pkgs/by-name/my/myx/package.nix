{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  alsa-lib,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "myx";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "HaseebKhalid1507";
    repo = "Myx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qSOpK+k1Rw7yJvMhaG4LbG7bfTtkuBw6BCzN9UkGrGY=";
  };

  cargoHash = "sha256-InX9HtZI686ukKLfLp4qOOWGg6DdKVMv8LsBOYf8M+c=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    openssl
  ];

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lean, beautiful terminal Spotify player";
    homepage = "https://github.com/HaseebKhalid1507/Myx";
    changelog = "https://github.com/HaseebKhalid1507/Myx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "myx";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ miniharinn ];
  };
})
