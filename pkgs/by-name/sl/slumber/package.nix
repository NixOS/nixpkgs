{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  zstd,
  aws-lc,
  sqlite,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "slumber";
  version = "5.4.4";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hx2JHuQ8CPWSgQ8yPUs+CymCmWnl2H2FyLwuo/m9xv0=";
  };

  cargoHash = "sha256-9iA60MSiKMojmPppyyuLV1UVHM76teygOY3fxwMIkrg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    aws-lc
    sqlite
    zstd
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "slumber";
    maintainers = with lib.maintainers; [ javaes ];
  };
})
