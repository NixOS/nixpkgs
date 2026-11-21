{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "khronoscope";
  version = "0-unstable-2025-02-25";

  src = fetchFromGitHub {
    owner = "hoyle1974";
    repo = "khronoscope";
    rev = "052eaa23101df6f1f68d049dbdfc4a75e92a2c6e";
    hash = "sha256-D9juPK09SGqbHJkA6QBEVXi/BiH0eGV69JyeZrTm78A=";
  };

  vendorHash = "sha256-rBjAuxsQwCBNcY8ydOI7/X/mSm6UARwR+dF2F/YVyWw=";

  subPackages = [ "cmd/khronoscope" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=main" ];
  };

  meta = {
    description = "Kubernetes cluster inspector that lets you rewind through cluster history";
    longDescription = ''
      Khronoscope is a Kubernetes cluster inspection tool inspired by k9s that
      records resource changes as your cluster runs and lets you rewind through
      its history with VCR-style controls. Supported resources include
      ConfigMaps, DaemonSets, Deployments, Namespaces, Nodes, PersistentVolumes,
      Pods, ReplicaSets, Secrets, and Services.
    '';
    homepage = "https://github.com/hoyle1974/khronoscope";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ connerohnesorge ];
    mainProgram = "khronoscope";
  };
})
