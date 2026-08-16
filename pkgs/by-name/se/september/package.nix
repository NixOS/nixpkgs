{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "september";
  version = "0.4.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gemrest";
    repo = "september";
    tag = "v${finalAttrs.version}";
    hash = "sha256-45xxiz93UhCCJFr3s0+Sgl4LMrUvRbMums1ZNngA1AY=";
  };

  cargoHash = "sha256-rpMnRx4/LdsVjAteY2LFm2j94XjneZ5E6c+pgZXOOr8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple & Efficient Gemini-to-HTTP Proxy";
    homepage = "https://github.com/gemrest/september";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mjm ];
    mainProgram = "september";
  };
})
