{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-secdump";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "jfjallid";
    repo = "go-secdump";
    tag = finalAttrs.version;
    hash = "sha256-ogBBG6wEiYNY6ngOwVHYYiIUHNXKNISNrL1qvkBAjRs=";
  };

  vendorHash = "sha256-bzvWdB/poT7mRCNIZU8ioRickwKExZl0ZtDrKi1T12o=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to remotely dump secrets from the Windows registry";
    homepage = "https://github.com/jfjallid/go-secdump";
    changelog = "https://github.com/jfjallid/go-secdump/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "go-secdump";
    platforms = lib.platforms.linux;
  };
})
