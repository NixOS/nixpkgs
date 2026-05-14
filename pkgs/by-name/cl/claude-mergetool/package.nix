{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
let
  version = "1.2.0";
in
rustPlatform.buildRustPackage {
  pname = "claude-mergetool";
  inherit version;

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "claude-mergetool";
    tag = "v${version}";
    hash = "sha256-d+tOjybFwWgJyI2YbAn6TF1utb7fNHrTbGp7I4yQ8UQ=";
  };

  cargoHash = "sha256-9YDILRyaWxqAmrAdQ2iDvTsn1VTFfFIpv0HMqi9U0q8=";

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
