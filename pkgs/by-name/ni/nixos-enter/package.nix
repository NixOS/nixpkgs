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

  meta = with lib; {
    description = "Run a command in a NixOS chroot environment";
    homepage = "https://github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/ni/nixos-install";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "nixos-enter";
  };
}
