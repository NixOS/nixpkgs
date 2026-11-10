{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  python3,
  gitMinimal,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gluesql";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "gluesql";
    repo = "gluesql";
    rev = "v${finalAttrs.version}";
    hash = "sha256-O2OkrUSeQQT7x4Z3chdFjpY1M1m/TAoU9viMgM9hCXg=";
  };

  nativeBuildInputs = [
    python3
  ];

  nativeCheckInputs = [
    gitMinimal
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.name "Nixpkgs Test"
    git config --global user.email "nobody@example.com"
  '';

  cargoHash = "sha256-U58pcgrFU4Kwz5vm5pOk4LOtEa19LVKEfqVp61G7VjM=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust library for SQL databases";
    homepage = "https://github.com/gluesql/gluesql";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.all;
  };
})
