{
  lib,
  rustPlatform,
  fetchFromGitHub,
  perl,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "samloader-rs";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "topjohnwu";
    repo = "samloader-rs";
    tag = finalAttrs.version;
    hash = "sha256-LgN/vGfb5hdy9/YH4x3+vFUjH97omGu2iNtkDJRMmsk=";
  };

  cargoHash = "sha256-o0+Kb8teYhuhvl8U6FiAq8Z6vd4IWA8k4Z104Z9BkMw=";

  nativeBuildInputs = [ perl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Download firmware for Samsung devices";
    homepage = "https://github.com/topjohnwu/samloader-rs";
    changelog = "https://github.com/topjohnwu/samloader-rs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "samloader";
  };
})
