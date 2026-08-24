{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ares-rs";
  version = "untagged-6f5c4d8ee9777328c6eb";

  src = fetchFromGitHub {
    owner = "bee-san";
    repo = "ares";
    tag = finalAttrs.version;
    hash = "sha256-TyRp+ffa98LGFOrotld+YA6qJ9ToGlEsvPS82XlNEXI=";
  };

  cargoHash = "sha256-R4FuKBegiYu9H4KIQ7nA18E2SL7OE2Io4SYwclhuM9U=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "Automated decoding of encrypted text without knowing the key or ciphers used";
    homepage = "https://github.com/bee-san/ares";
    changelog = "https://github.com/bee-san/Ares/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ares";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
