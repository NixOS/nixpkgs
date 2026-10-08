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
  version = "0.5.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gemrest";
    repo = "september";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y9dn8ix/cZ+WD81/zIeeWk2ggPHXPP9D5gT9xEuc7+k=";
  };

  cargoHash = "sha256-iSrqiCIALvhl2mYmJydExsbAORTXen1j5UG5Mc45As0=";

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
