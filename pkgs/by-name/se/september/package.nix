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
  version = "0.5.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gemrest";
    repo = "september";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ea/gvHtjUGTIrSP949Woi0gRWR5RXibHlCcRJAK3pIk=";
  };

  cargoHash = "sha256-5CjaVOMk++47ekTzvZWFQU4WHcCOcUgpS6zOqBNwW34=";

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
