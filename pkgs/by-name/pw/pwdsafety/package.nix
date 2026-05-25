{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pwdsafety";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "pwdsafety";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/kLnlOJu+G+RDVhjH+zsXzF2PdFhqu8ZOz72wqbuixU=";
  };

  vendorHash = "sha256-4Nd4QU934XpCOH6aqiGLvRbfuPu+z4WwzxBIb/SPH8w=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Command line tool checking password safety";
    homepage = "https://github.com/edoardottt/pwdsafety";
    changelog = "https://github.com/edoardottt/pwdsafety/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pwdsafety";
  };
})
