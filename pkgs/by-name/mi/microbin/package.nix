{
  fetchFromGitHub,
  lib,
  oniguruma,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "microbin";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "szabodanika";
    repo = "microbin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ipSMiUJgbZ0kijGs7Ok8bRTGdFzygIPEY6ZuJ/eRb9s=";
  };

  cargoHash = "sha256-vvSQfXu67RNBXzfDIE2rcfUOcAfTACaVRvSBBITJ9gY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    oniguruma
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiny, self-contained, configurable paste bin and URL shortener written in Rust";
    homepage = "https://github.com/szabodanika/microbin";
    changelog = "https://github.com/szabodanika/microbin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [
    ];
    mainProgram = "microbin";
  };
})
