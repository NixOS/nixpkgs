{ ... }:
let
    interfaces_file = "/etc/nixos/vagrant-interfaces.nix";
    interfaces_config =
        if builtins.pathExists (builtins.toPath interfaces_file)
        then [interfaces_file]
        else [];
in
{
    imports = [
        /etc/nixos/hardware-configuration.nix
        /etc/nixos/vagrant.nix] ++
        interfaces_config;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # remove the fsck that runs at startup. It will always fail to run, stopping
  # your boot until you press *.
  boot.initrd.checkJournalingFS = false;

  # Vagrant cannot yet handle udev's new predictable interface names.
  # Use the old ethX naming system for the moment.
  # http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
  networking.usePredictableInterfaceNames = false;

  # In vagrant the location is set to vagrant to fix various other settings.
  flyingcircus.enc.parameters.location = "vagrant";

  # Enable DHCP on eth0 for vagrant to be able to actually do things.
  networking.interfaces.eth0.useDHCP = true;

  # Enable guest additions.
  virtualisation.virtualbox.guest.enable = true;

  # Creates a "vagrant" users with password-less sudo access
  users.extraGroups = [
    { name = "login"; }
    { name = "vagrant"; }
    { name = "vboxsf"; }
  ];
  users.extraUsers  = [
      # Try to avoid ask password
      { name = "root"; password = "vagrant"; }
      {
        description     = "Vagrant User";
        name            = "vagrant";
        group           = "vagrant";
        extraGroups     = [ "users" "vboxsf" "wheel" "login" ];
        password        = "vagrant";
        home            = "/home/vagrant";
        createHome      = true;
        useDefaultShell = true;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
        ];
      }
    ];

  security.sudo.extraConfig =
    ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults env_keep+=SSH_AUTH_SOCK
      Defaults lecture = never
      root   ALL=(ALL) SETENV: ALL
      %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
    '';
}
