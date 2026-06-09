{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "misconfig-mapper";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cxBoGk9K9Y2mtkAM4JW3XoQi+MrOGhRmQ3iRKF2cueA=";
  };

  vendorHash = "sha256-jM+td4OUDK7Z4zZy/w0foupQMYpFhOTIefSUoovgEeE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to uncover security misconfigurations on popular third-party services";
    homepage = "https://github.com/intigriti/misconfig-mapper";
    changelog = "https://github.com/intigriti/misconfig-mapper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "misconfig-mapper";
  };
})
