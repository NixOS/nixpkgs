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
  version = "0.5.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gemrest";
    repo = "september";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c0o0jH2ZkdJzzc/ZbnVhvA7wBAB0GEjwf1qBYa9mbbg=";
  };

  cargoHash = "sha256-+h+CV1L6lvca9ryFUNtxZ5nswGmxx4Rcv/2qp32IZok=";

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
