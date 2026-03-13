{
  lib,
  gitMinimal,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "gitcs";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "hrtsegv";
    repo = "gitcs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eAza/ni8MYrve0YCTkleOyOXPWmH4CEh8j5L+78wzsQ=";
  };

  vendorHash = "sha256-bG0BaH8yYp8TUiK/7xvghB4T48LcBEvmF1uvY5eYkww=";

  env.CGO_ENABLED = 0;

  ldflags = [ "-s" ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    git config --global init.defaultBranch main
    bash ./setup-test.sh
  '';

  meta = {
    changelog = "https://github.com/hrtsegv/gitcs/releases/tag/v${finalAttrs.version}";
    description = "Scan local git repositories and generate a visual contributions graph";
    homepage = "https://github.com/hrtsegv/gitcs";
    license = lib.licenses.mit;
    mainProgram = "gitcs";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
