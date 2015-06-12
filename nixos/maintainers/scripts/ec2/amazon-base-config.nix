{ modulesPath, ...}:
{
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
  services.journald.rateLimitBurst = 0;
}
