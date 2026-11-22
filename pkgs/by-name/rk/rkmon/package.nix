{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "rkmon";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "isac322";
    repo = "rkmon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JDAJfXll8tNyGRQ4e9GmeW9QHWGPgxabH3hGq6kO0dM=";
  };

  vendorHash = "sha256-x3i0/v/3o2DXdrARDi0gAPxc4pOtYKwngn1IkBIJ9A4=";

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
