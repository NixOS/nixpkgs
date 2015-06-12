{ modulesPath, ...}:
{
  imports = [ "${modulesPath}/virtualisation/amazon-init.nix" ];
  services.journald.rateLimitBurst = 0;
}
