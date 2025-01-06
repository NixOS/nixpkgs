{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-secdump";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "jfjallid";
    repo = "go-secdump";
    tag = version;
    hash = "sha256-HZAt/lSe13OjCjpJMNCvWoenhCMc2YGoys0S1eiLeKo=";
  };

  vendorHash = "sha256-hqbLfhUJSSWCdt+f1Z9Pn4TYEWytqAZxwWpqxlrlN9o=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to remotely dump secrets from the Windows registry";
    homepage = "https://github.com/jfjallid/go-secdump";
    changelog = "https://github.com/jfjallid/go-secdump/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "go-secdump";
    platforms = lib.platforms.linux;
  };
}
