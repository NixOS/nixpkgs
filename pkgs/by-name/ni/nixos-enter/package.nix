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

  meta = {
    description = "Run a command in a NixOS chroot environment";
    homepage = "https://github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/ni/nixos-install";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "nixos-enter";
  };
}
