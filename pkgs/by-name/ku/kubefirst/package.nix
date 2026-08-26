{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubefirst";
  version = "2.10.5";

  src = fetchFromGitHub {
    owner = "konstructio";
    repo = "kubefirst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2rxvUbf94cG/56ri3GXKpHSoqSXg2cfu5wpm4UUjpVE=";
  };

  vendorHash = "sha256-/su9f8JVXaJrC7/rcX1LK/amolVmkRAtPF1bqzxcKh8=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/konstructio/kubefirst-api/configs.K1Version=v${finalAttrs.version}"
  ];

  doCheck = false;

  meta = {
    description = "Tool to create instant GitOps platforms that integrate some of the best tools in cloud native from scratch";
    mainProgram = "kubefirst";
    homepage = "https://github.com/konstructio/kubefirst/";
    changelog = "https://github.com/konstructio/kubefirst/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qjoly ];
  };
})
