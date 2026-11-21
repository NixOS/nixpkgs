{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "sish";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = "sish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wT3mjV5k4cQjXq2UWVdxZpqAvs42RgsRxN4rn+pH01E=";
  };

  vendorHash = "sha256-iEm9nYsXVLkEJWtGBQ5B909T/X1h2+0ySuS82m/of38=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/antoniomika/sish/cmd.Commit=${finalAttrs.src.rev}"
    "-X=github.com/antoniomika/sish/cmd.Date=1970-01-01"
    "-X=github.com/antoniomika/sish/cmd.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  meta = {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    changelog = "https://github.com/antoniomika/sish/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sish";
  };
})
