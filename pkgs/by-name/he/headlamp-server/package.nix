{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update,
  writeShellScript,
}:

buildGoModule rec {
  pname = "headlamp-server";
  version = "0.42.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "headlamp";
    tag = "v${version}";
    hash = "sha256-SBPSh6dsKvMw1C80THri0mNPoTMgcrjONk455S/g9v0=";
  };

  modRoot = "backend";

  vendorHash = "sha256-dBU053QtUEMWjzkOEHzELH3j7PJOKuoBZCVZFmZ5z7E=";

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
