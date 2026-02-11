{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "chkbit";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "laktak";
    repo = "chkbit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zf5UNpTsdTRym9B2xfuRIBl4Mpv97K+4VVbVPTEWFms=";
  };

  vendorHash = "sha256-hiXn7LmO4bYti9iufonQSLM1G0BZGB8u0QRqSYBvxNc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${finalAttrs.version}"
  ];

  # Tests expect binary to be in the source directory
  preCheck = ''
    ln -s ../go/bin/chkbit .
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Check your files for data corruption and run quick file deduplication";
    homepage = "https://github.com/laktak/chkbit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qubitnano ];
    mainProgram = "chkbit";
  };
})
