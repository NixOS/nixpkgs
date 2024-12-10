{
  lib,
  buildGo123Module,
  fetchFromGitHub,
}:

buildGo123Module rec {
  pname = "gotemplate";
  version = "3.9.2";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7FJejArGpnmkAzbN+2BOcewLdlcsh8QblOOZjFu+uSA=";
  };

  vendorHash = "sha256-378oodyQG50l7qkTO5Ryt1NjFBbYW2n9by+ALNfTggI=";

  # This is the value reported when running `gotemplate --version`,
  # see https://github.com/coveooss/gotemplate/issues/262
  ldflags = [ "-X main.version=${version}" ];

  meta = with lib; {
    description = "CLI for go text/template";
    mainProgram = "gotemplate";
    changelog = "https://github.com/coveooss/gotemplate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ giorgiga ];
  };
}
