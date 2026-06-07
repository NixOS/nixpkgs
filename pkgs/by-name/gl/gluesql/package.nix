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
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "gluesql";
    repo = "gluesql";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/Yb6ksHxFscB/t7fID11fNHldJ0lDmN9DXbiaG+mUwY=";
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

  cargoHash = "sha256-P2YH3mf1Olrjzwl6ldwzO0xMC0yccqA7T2mrWZ5qSKM=";

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
