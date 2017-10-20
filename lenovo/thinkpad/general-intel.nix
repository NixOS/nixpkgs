{ ... }:

{
  boot.kernelModules = mkDefault [ "kvm-intel" ];
  services.xserver.videoDrivers = [ "intel" ];
}
