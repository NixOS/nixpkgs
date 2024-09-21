{
  lib,
  substituteAll,
  runtimeShell,
  installShellFiles,
  util-linuxMinimal,
}:
substituteAll {
  name = "nixos-enter";
  src = ./nixos-enter.sh;

  inherit runtimeShell;

  path = lib.makeBinPath [
    util-linuxMinimal
  ];

  dir = "bin";
  isExecutable = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ${./nixos-enter.8}
  '';

  meta.mainProgram = "nixos-enter";
}
