{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "beadwork";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "jallum";
    repo = "beadwork";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OVwr/AUIx6k5QF2rZf25BWD+3UHYqN8tziJTa8tgDYU=";
  };

  vendorHash = "sha256-LjqZSI7F3C8GyNrPK/BwG9QTmNg89hFAvhUuBjmbHTU=";

  subPackages = [ "cmd/bw" ];

  nativeCheckInputs = [
    gitMinimal
    versionCheckHook
  ];

  doCheck = true;
  doInstallCheck = true;

  preCheck = ''
    export HOME="$TMPDIR"
    git config --global user.email "test@test.com"
    git config --global user.name "Test"
    git config --global init.defaultBranch main
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Git-native work management for AI coding agents";
    homepage = "https://github.com/jallum/beadwork";
    license = licenses.mit;
    mainProgram = "bw";
    maintainers = with lib.maintainers; [ munksgaard ];
  };

  __structuredAttrs = true;
})
