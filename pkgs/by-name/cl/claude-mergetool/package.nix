{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
let
  version = "1.1.0";
in
rustPlatform.buildRustPackage {
  pname = "claude-mergetool";
  inherit version;

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "claude-mergetool";
    tag = "v${version}";
    hash = "sha256-MqAtr7SxbarllzDgOWvzUooiRNf08aAVaLdZHJzMnRI=";
  };

  cargoHash = "sha256-RawDKKx+O79+TnLZRdatEcNDd4vLzTqHF2w1/D5zPjA=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/claude-mergetool";

  meta = {
    homepage = "https://github.com/9999years/claude-mergetool";
    changelog = "https://github.com/9999years/claude-mergetool/releases/tag/v${version}";
    description = "Resolve Git/jj merge conflicts automatically with claude-code";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers._9999years ];
    mainProgram = "claude-mergetool";
  };

  passthru.updateScript = nix-update-script { };
}
