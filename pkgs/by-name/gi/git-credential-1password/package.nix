{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "git-credential-1password";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ethrgeist";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-KiMpBQ4jEm2pXRitfZLEyGjkKJHC2KNKIX8tfenVTAw=";
  };

  vendorHash = null;

  meta = {
    description = "A git credential helper for 1Password";
    homepage = "https://github.com/ethrgeist/git-credential-1password";
    changelog = "https://github.com/ethrgeist/git-credential-1password/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nanamiiiii ];
    mainProgram = "git-credential-1password";
  };
}
