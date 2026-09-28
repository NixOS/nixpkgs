{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "matterircd";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-maIc7HgzW4mhz59WFmm26tJddC70kvF2GdsYZ0HW9AU=";
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
