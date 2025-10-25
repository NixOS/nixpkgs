{
  lib,
  ...
}:
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "networking" "networkmanager" "packages" ]
      [ "networking" "networkmanager" "plugins" ]
    )
    (lib.mkRenamedOptionModule
      [ "networking" "networkmanager" "useDnsmasq" ]
      [ "networking" "networkmanager" "dns" ]
    )
    (lib.mkRemovedOptionModule [ "networking" "networkmanager" "extraConfig" ] ''
      This option was removed in favour of `networking.networkmanager.settings`,
      which accepts structured nix-code equivalent to the ini
      and allows for overriding settings.
      Example patch:
      ```patch
         networking.networkmanager = {
      -    extraConfig = '''
      -      [main]
      -      no-auto-default=*
      -    '''
      +    settings.main.no-auto-default = "*";
         };
      ```
    '')
    (lib.mkRemovedOptionModule [ "networking" "networkmanager" "enableFccUnlock" ] ''
      This option was removed, because using bundled FCC unlock scripts is risky,
      might conflict with vendor-provided unlock scripts, and should
      be a conscious decision on a per-device basis.
      Instead it's recommended to use the
      `networking.modemmanager.fccUnlockScripts` option.
    '')
    (lib.mkRemovedOptionModule [ "networking" "networkmanager" "dynamicHosts" ] ''
      This option was removed because allowing (multiple) regular users to
      override host entries affecting the whole system opens up a huge attack
      vector. There seem to be very rare cases where this might be useful.
      Consider setting system-wide host entries using networking.hosts, provide
      them via the DNS server in your network, or use environment.etc
      to add a file into /etc/NetworkManager/dnsmasq.d reconfiguring hostsdir.
    '')
    (lib.mkRemovedOptionModule [ "networking" "networkmanager" "firewallBackend" ] ''
      This option was removed as NixOS is now using iptables-nftables-compat even when using iptables, therefore Networkmanager now uses the nftables backend unconditionally.
    '')
    (lib.mkRenamedOptionModule
      [ "networking" "networkmanager" "fccUnlockScripts" ]
      [ "networking" "modemmanager" "fccUnlockScripts" ]
    )
    (lib.mkRemovedOptionModule [
      "networking"
      "networkmanager"
      "enableStrongSwan"
    ] "Pass `pkgs.networkmanager-strongswan` into `networking.networkmanager.plugins` instead.")
    (lib.mkRemovedOptionModule [
      "networking"
      "networkmanager"
      "enableDefaultPlugins"
    ] "Configure the required plugins explicitly in `networking.networkmanager.plugins`.")
  ];
}
