{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  testers,
  avml,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "avml";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "avml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iBlY5dkc5uKgp+hf2j56J5aqqQ9sF/ob4qnQy1vzPfQ=";
  };

  cargoHash = "sha256-CnFIC5nMffXcZ6cQL7G93tSXJwczMFOty3dcqCy5DTc=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  passthru.tests.version = testers.testVersion { package = avml; };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Portable volatile memory acquisition tool for Linux";
    homepage = "https://github.com/microsoft/avml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lesuisse ];
    platforms = lib.platforms.linux;
    mainProgram = "avml";
  };
})
