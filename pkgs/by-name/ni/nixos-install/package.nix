{
  lib,
  substituteAll,
  runtimeShell,
  installShellFiles,
  nix,
  jq,
  nixos-enter,
  util-linuxMinimal,
}:
substituteAll {
  name = "nixos-install";
  src = ./nixos-install.sh;

  inherit runtimeShell nix;

  path = lib.makeBinPath [
    jq
    nixos-enter
    util-linuxMinimal
  ];

  dir = "bin";
  isExecutable = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ${./nixos-install.8}
  '';

  meta.mainProgram = "nixos-install";
}
