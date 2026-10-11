{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "docker-dash";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "GustavoCaso";
    repo = "docker-dash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MM4cuF99j0l8c2bwnXwnzKFykYijTbitN17Wz72H2yw=";
  };

  vendorHash = "sha256-yY/oKPvxUMHmowfqRHDlDNO4cDqCQndE/MRlH0UbVo8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Keyboard-first Docker dashboard for the terminal";
    mainProgram = "docker-dash";
    homepage = "https://github.com/GustavoCaso/docker-dash";
    changelog = "https://github.com/GustavoCaso/docker-dash/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kangazero
    ];
  };
})
