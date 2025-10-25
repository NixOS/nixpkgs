{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "gh-webhook";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "gh-webhook";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IfyOnpW5xEylqyZs3VKbLbRyjIzPGCo4AwYlyaMvQdI=";
  };

  vendorHash = "sha256-wiNIb7heeRVd3Yoa6cg4Dh+PnDnzEhx2KAbNH2cmeg0=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "GitHub CLI extension to chatter with Webhooks";
    homepage = "https://github.com/cli/gh-webhook";
    license = lib.licenses.unfree; # no upstream license, see https://github.com/cli/gh-webhook/issues/38
    maintainers = with lib.maintainers; [ adamperkowski ];
    mainProgram = "gh-webhook";
  };
})
