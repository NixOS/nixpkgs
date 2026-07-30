{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nodejs_24,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "github-act-runner";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "ChristopherHX";
    repo = "github-act-runner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bcpaw3tVCkpxMmjxKTxu1H3amlawbIS0UdH0+qWEv18=";
  };

  vendorHash = "sha256-JS+8A6/JiIctCFzZQl1GqfSGv5yZT64++0BgYC8sulE=";

  ldflags = [
    "-s"
    "-X main.version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/github-act-runner \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs_24
          gitMinimal
        ]
      }
  '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Reverse-engineered self-hosted GitHub Actions runner (Go)";
    homepage = "https://github.com/ChristopherHX/github-act-runner";
    changelog = "https://github.com/ChristopherHX/github-act-runner/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "github-act-runner";
  };
})
