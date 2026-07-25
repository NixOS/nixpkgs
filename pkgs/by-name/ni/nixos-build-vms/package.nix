{
  replaceVarsWith,
  runtimeShell,
  installShellFiles,
  lib,
}:
replaceVarsWith {
  pname = "nixos-build-vms";
  version = lib.trivial.release;

  src = ./nixos-build-vms.sh;

  replacements = {
    inherit runtimeShell;
    buildVms = "${./build-vms.nix}";
  };

  dir = "bin";
  isExecutable = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ${./nixos-build-vms.8}
  '';

  meta.mainProgram = "nixos-build-vms";
}
