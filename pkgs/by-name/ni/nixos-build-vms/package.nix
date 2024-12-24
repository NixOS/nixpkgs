{
  substituteAll,
  runtimeShell,
  installShellFiles,
}:
substituteAll {
  name = "nixos-build-vms";
  src = ./nixos-build-vms.sh;
  inherit runtimeShell;
  buildVms = ./build-vms.nix;

  dir = "bin";
  isExecutable = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ${./nixos-build-vms.8}
  '';

  meta.mainProgram = "nixos-build-vms";
}
