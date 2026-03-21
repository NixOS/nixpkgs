{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "mactop";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "metaspartan";
    repo = "mactop";
    tag = "v${version}";
    hash = "sha256-0M3nV3gjsY1vg+uqXbKUAF/8311jc8UJ2UYUFyrRiAo=";
  };

  vendorHash = "sha256-nlbifuj4kued8ugawAfd4V6uirkQEZ1yRQXVsF+ZEdc=";

  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Terminal-based monitoring tool 'top' designed to display real-time metrics for Apple Silicon chips";
    homepage = "https://github.com/metaspartan/mactop";
    changelog = "https://github.com/metaspartan/mactop/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "mactop";
    platforms = [ "aarch64-darwin" ];
  };
}
