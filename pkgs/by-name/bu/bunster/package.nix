{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  util-linux,
}:

buildGoModule rec {
  pname = "bunster";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "yassinebenaid";
    repo = "bunster";
    tag = "v${version}";
    hash = "sha256-7OT4C4A65Q662sO9yGPsYO5Tjph6Defro8+89b8etu0=";
  };

  vendorHash = "sha256-Npm4LEINzeAf8qof0Sp86MIxA3uPRjdkMTHn+gtQrfQ=";

  nativeCheckInputs = [ util-linux ];
  checkFlags = [ "-skip=TestBunster/tests/(conditionals|builtins|01)" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Compile shell scripts to static binaries";
    homepage = "https://github.com/yassinebenaid/bunster";
    changelog = "https://github.com/yassinebenaid/bunster/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      yunz
    ];
    mainProgram = "bunster";
    platforms = lib.platforms.unix;
  };
}
