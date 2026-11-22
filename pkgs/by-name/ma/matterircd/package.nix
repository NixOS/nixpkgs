{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "matterircd";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-W1d21/fqe4eUaKEV0Ltt4lCsXnGrCZ60FaPZAaN7izU=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Minimal IRC server bridge to Mattermost";
    mainProgram = "matterircd";
    homepage = "https://github.com/42wim/matterircd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ numinit ];
  };
})
