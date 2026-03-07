{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mactop";
  version = "2.0.9";

  src = fetchFromGitHub {
    owner = "metaspartan";
    repo = "mactop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J+ebxVV5aNTz0qtBkd8G4NX0EB7wWkWIIzS0h/jvQWI=";
  };

  vendorHash = "sha256-nlbifuj4kued8ugawAfd4V6uirkQEZ1yRQXVsF+ZEdc=";

  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  doCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based monitoring tool 'top' designed to display real-time metrics for Apple Silicon chips";
    homepage = "https://github.com/metaspartan/mactop";
    changelog = "https://github.com/metaspartan/mactop/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      metaspartan
    ];
    mainProgram = "mactop";
    platforms = [ "aarch64-darwin" ];
  };
}
