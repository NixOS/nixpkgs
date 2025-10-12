{ lib, ... }:

{

  # Bashless builds on perlless
  imports = [ ./perlless.nix ];

  # Remove bash from activation
  system.nixos-init.enable = lib.mkDefault true;
  system.activatable = lib.mkDefault false;
  environment.shell.enable = lib.mkDefault false;
  programs.bash.enable = lib.mkDefault false;

  # Random bash remnants
  environment.corePackages = lib.mkForce [ ];
  # Contains bash completions
  nix.enable = lib.mkDefault false;
  # The fuse{,3} package contains a runtime dependency on bash.
  programs.fuse.enable = lib.mkDefault false;
  documentation.man.man-db.enable = lib.mkDefault false;
  # autovt depends on bash
  console.enable = lib.mkDefault false;
  # dhcpcd and openresolv depend on bash
  networking.useNetworkd = lib.mkDefault true;
  # bcache tools depend on bash.
  boot.bcache.enable = lib.mkDefault false;
  # iptables depends on bash and nixos-firewall-tool is a bash script
  networking.firewall.enable = lib.mkDefault false;
  # the wrapper script is in bash
  security.enableWrappers = lib.mkDefault false;
  # kexec script is written in bash
  boot.kexec.enable = lib.mkDefault false;
  # Relies on bash scripts
  powerManagement.enable = lib.mkDefault false;
  # Has some bash inside
  systemd.shutdownRamfs.enable = lib.mkDefault false;
  # Relies on the gzip command which depends on bash
  services.logrotate.enable = lib.mkDefault false;

  # Check that the system does not contain a Nix store path that contains the
  # string "bash".
  system.forbiddenDependenciesRegexes = [ "bash" ];

}
