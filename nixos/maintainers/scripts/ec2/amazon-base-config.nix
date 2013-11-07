{ modulesPath, ...}:
{
  imports = [ "${modulesPath}/virtualisation/amazon-config.nix" ];
  services.journald.rateLimitBurst = 0;
}
