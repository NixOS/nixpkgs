{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "mactop";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "metaspartan";
    repo = "mactop";
    tag = "v${version}";
    hash = "sha256-0r9ZL9LZ9Y5L3AeM+d09poLTWQKhg/0iJjjPhT1+zjE=";
  };

  vendorHash = "sha256-PrZaun9Bzx0hLy0aIHFGmO/RA0fMrtZfKSypPs55Pc8=";

  postPatch = ''
    substituteInPlace go.mod --replace-fail "go 1.25.5" "go 1.25.4"
  '';

  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

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
