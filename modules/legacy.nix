{
  require = [
    ../system/assertion.nix
    ../system/nixos-environment.nix
    ../system/nixos-installer.nix
    ../upstart-jobs/cron/locate.nix
    ../upstart-jobs/ldap
    ../upstart-jobs/pcmcia.nix
  ];
}
