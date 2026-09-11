{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  testers,
  nix-update-script,
  moonpalace,
}:
buildGoModule rec {
  pname = "moonpalace";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "MoonshotAI";
    repo = "moonpalace";
    tag = "v${version}";
    hash = "sha256-30ibs49srFwTsnjbtvLUNQ79yA/vZJdlHQZ8ERi5lls=";
  };
  vendorHash = "sha256-e5G+28cgUJvUpS1CX/Tinn3gDK8fNEcJi8uv9xMR+5o=";

  passthru = {
    tests.version = testers.testVersion {
      package = moonpalace;
      version = "v${moonpalace.version}";
      command = "HOME=$(mktemp -d) moonpalace --version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "API debugging tool provided by Moonshot AI";
    homepage = "https://github.com/MoonshotAI/moonpalace";
    changelog = "https://github.com/MoonshotAI/moonpalace/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "moonpalace";
  };
}
