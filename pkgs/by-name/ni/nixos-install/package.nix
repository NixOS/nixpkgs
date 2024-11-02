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

  meta = {
    description = "Install bootloader and NixOS";
    homepage = "https://github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/ni/nixos-install";
    license = lib.licenses.mit;
    mainProgram = "nixos-install";
  };
}
