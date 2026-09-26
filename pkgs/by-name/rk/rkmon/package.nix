{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "rkmon";
  version = "0.3.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "isac322";
    repo = "rkmon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LFvv/CvZxtulGQdFVU7XVDitzgQwkOIFF9mfZBAUe1Y=";
  };

  vendorHash = "sha256-f9+5iVGvkLuFHqDdeSvx4Vu6paVsRS0EZxKB9a3sr/I=";

  ldflags = [
    "-s"
    "-w"
    "-extldflags"
    "-static"
    "-X=main.Version=${finalAttrs.version}"
    "-X=main.GitSHA=${finalAttrs.src.rev}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real-time hardware monitor TUI for Rockchip RK3588 SBCs. Like htop, but for the GPU, NPU, VPU, RGA, and thermal zones of your Rock 5B+ / RK3588 board";
    homepage = "https://github.com/isac322/rkmon";
    changelog = "https://github.com/isac322/rkmon/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "rkmon";
  };
})
