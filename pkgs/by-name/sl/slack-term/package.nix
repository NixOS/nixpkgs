{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "slack-term";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "jpbruinsslot";
    repo = "slack-term";
    tag = "v${finalAttrs.version}";
    hash = "sha256-poY4TTDEha5S7eO8mwrYYNqqZHs13kvnpBAcD9s6eLk=";
  };
  vendorHash = null;

  meta = {
    description = "Slack client for your terminal";
    homepage = "https://github.com/jpbruinsslot/slack-term";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "slack-term";
  };
})
