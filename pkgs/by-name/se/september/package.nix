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
  version = "0.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gemrest";
    repo = "september";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g50hWDuf5TgzI8vfQAAkNYZs6UTIve7IX+fNTWzxu4w=";
  };

  cargoHash = "sha256-tOoiIKeG/b1l/TpTD1K1ZRhVDcWxNILhKqLpJp7QIec=";

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
