{
  boot.kernelModules = [ "kvm-intel" ];
  services.xserver.videoDrivers = [ "intel" ];
}
