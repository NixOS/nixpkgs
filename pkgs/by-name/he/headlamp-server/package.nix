{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update,
  writeShellScript,
}:

buildGoModule (finalAttrs: {
  pname = "headlamp-server";
  version = "0.43.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "headlamp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6TGKBKR0WR4Xv7lGCgMFVG/nc19oMOP5cJcgT0bw6Ag=";
  };

  modRoot = "backend";

  vendorHash = "sha256-U0H1Dj38ajRGFqcWszveWckxenaKa4nrPg81GyIpS0U=";

  # Don't embed frontend - Electron serves it directly. This also prevents
  # the server from auto-opening a browser window.

  ldflags = [
    "-s"
    "-w"
    "-X github.com/kubernetes-sigs/headlamp/backend/pkg/kubeconfig.Version=${finalAttrs.version}"
    "-X github.com/kubernetes-sigs/headlamp/backend/pkg/kubeconfig.AppName=Headlamp"
  ];

  subPackages = [ "cmd" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/headlamp-server
  '';

  # headlamp-frontend and headlamp inherit src (and version) from here, update their hashes aswell
  passthru.updateScript = writeShellScript "headlamp-update" ''
    set -euo pipefail
    ${lib.getExe nix-update} headlamp-server
    ${lib.getExe nix-update} --version=skip --no-src headlamp-frontend
    ${lib.getExe nix-update} --version=skip --no-src headlamp
  '';

  meta = {
    description = "An easy-to-use and extensible Kubernetes web UI";
    homepage = "https://headlamp.dev";
    changelog = "https://github.com/kubernetes-sigs/headlamp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dylanmtaylor ];
    mainProgram = "headlamp-server";
  };
})
