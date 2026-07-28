{
  nixos,
  lib,
  runCommand,
}:
let
  base = nixos {
    services.userborn.enable = true;
    programs.nix-required-mounts = {
      enable = true;
      presets.nvidia-gpu.enable = true;
    };
    fileSystems."/".device = "/dev/null";
    boot.loader.grub.enable = false;
    system.stateVersion = lib.trivial.release;
  };
  machine = base.extendModules {
    modules = [ { hardware.graphics.enable = true; } ];
  };
in
runCommand "nix-required-mounts-eval-nvidia-gpu-preset" { } ''
  echo "Successfully evaluated ${base.config.system.build.toplevel}"
  echo "Successfully evaluated ${machine.config.system.build.toplevel}"
  echo "This means that combining nix-required-mounts with userborn no longer causes infinite recursion (#488199)"
  touch $out
''
