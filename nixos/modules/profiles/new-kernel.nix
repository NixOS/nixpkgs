{
  lib,
  pkgs,
  ...
}:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "bcachefs" ];
  # Might be required as a workaround for bcachefs bug
  # https://github.com/NixOS/nixpkgs/issues/32279#issuecomment-1093682970
  boot.postBootCommands = ''
    ${lib.getExe pkgs.keyutils "keyctl"} link @u @s
  '';
}
