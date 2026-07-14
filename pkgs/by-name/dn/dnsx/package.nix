{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "dnsx";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "dnsx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XtjNdqUS1l6Ct5s+OXmmwvpuckKTaHD2S4tn39Tvf1Y=";
  };

  vendorHash = "sha256-ng0S/oFnrSlJ6a2UIZ3IrZx0Tb8Mru9BOuHBqH/1ctU=";

  subPackages = [ "cmd/dnsx" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require network access
  doCheck = false;

  doInstallCheck = true;

  versionCheckProgramArg = "-version";

  meta = {
    description = "Fast and multi-purpose DNS toolkit";
    longDescription = ''
      dnsx is a fast and multi-purpose DNS toolkit allow to run multiple
      probers using retryabledns library, that allows you to perform
      multiple DNS queries of your choice with a list of user supplied
      resolvers.
    '';
    homepage = "https://github.com/projectdiscovery/dnsx";
    changelog = "https://github.com/projectdiscovery/dnsx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dnsx";
  };
})
