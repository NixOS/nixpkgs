{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update,
  writeShellScript,
}:

buildGoModule rec {
  pname = "headlamp-server";
  version = "0.45.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "headlamp";
    tag = "v${version}";
    hash = "sha256-Q/15vBSO3vjTrYQW6YZ9oMGVr2EjFor+hKGehFTaQNQ=";
  };

  modRoot = "backend";

  vendorHash = "sha256-6hOxJpC9SlR6Oa0mKA8SziTdNS81l27eNYM1v0KOod0=";

  # Don't embed frontend - Electron serves it directly. This also prevents
  # the server from auto-opening a browser window.

  ldflags = [
    "-s"
    "-w"
    "-X github.com/kubernetes-sigs/headlamp/backend/pkg/kubeconfig.Version=${version}"
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
    changelog = "https://github.com/kubernetes-sigs/headlamp/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dylanmtaylor ];
    mainProgram = "headlamp-server";
  };
}
