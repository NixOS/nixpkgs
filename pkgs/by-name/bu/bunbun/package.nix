{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "bunbun";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "devraza";
    repo = "bunbun";
    tag = "v${version}";
    hash = "sha256-3f/G0Vx1uXeH3QMDVUAHWi4Pf/B88/4F+4XywVsp3/4=";
  };

  cargoHash = "sha256-2pgQB2myEnLvrU3ApNL/bwaVcGku+X/TjR6YBqXD7Xg=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple and adorable sysinfo utility written in Rust";
    homepage = "https://github.com/devraza/bunbun";
    changelog = "https://github.com/devraza/bunbun/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "bunbun";
  };
}
