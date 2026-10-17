{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "matterircd";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-auMd4coShEp4EKtxZhFlMXokZtF5SCqIgiSP1BGHn5U=";
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
