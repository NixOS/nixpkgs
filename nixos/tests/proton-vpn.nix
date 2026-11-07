{ pkgs, ... }:
let
  python = pkgs.python3.withPackages (ps: [ ps.proton-vpn-daemon ]);
  checkBackends = pkgs.writeText "check-proton-vpn-backends.py" ''
    import gi
    gi.require_version("NM", "1.0")
    from gi.repository import NM
    from proton.loader import Loader

    assert any(p.get_name() == "protun" for p in NM.VpnPluginInfo.list_load())
    assert Loader.get("split_tunneling").__name__ == "SplitTunnelingDbusClient"
  '';
in
{
  name = "proton-vpn";

  meta.maintainers = with pkgs.lib.maintainers; [ schembriaiden ];

  nodes.machine = {
    imports = [ ../modules/programs/proton-vpn.nix ];
    programs.proton-vpn.gui.enable = true;
    users.users.alice.isNormalUser = true;
    virtualisation.memorySize = 2048;
  };

  nodes.cli = {
    imports = [ ../modules/programs/proton-vpn.nix ];
    programs.proton-vpn.cli.enable = true;
    users.users.alice.isNormalUser = true;
    virtualisation.memorySize = 2048;
  };

  testScript = ''
    machine.wait_for_unit("NetworkManager.service")
    machine.wait_for_unit("me.proton.vpn.split_tunneling.service")
    machine.succeed("install -d -o alice -m 700 /run/user/1000")

    with subtest("GUI-only installation"):
        machine.succeed("test -x /run/current-system/sw/bin/protonvpn-app")
        machine.fail("test -e /run/current-system/sw/bin/protonvpn")

    with subtest("NetworkManager plugin"):
        machine.succeed("test -e /etc/NetworkManager/VPN/nm-protun.name")
        machine.succeed("test -x $(sed -n 's/^program=//p' /etc/NetworkManager/VPN/nm-protun.name)")

    with subtest("Split tunneling daemon and system bus policy"):
        # The daemon compiles and loads its eBPF socket program before exporting
        # this interface, so a successful call also checks the kernel headers.
        machine.wait_until_succeeds(
            "su - alice -c 'busctl --system call me.proton.vpn.split_tunneling "
            "/me/proton/vpn/split_tunneling me.proton.vpn.split_tunneling GetAllConfigs'"
        )

    with subtest("Backend discovery as an ordinary user"):
        machine.succeed(
            "su - alice -c 'XDG_RUNTIME_DIR=/run/user/1000 "
            "GI_TYPELIB_PATH=${pkgs.networkmanager}/lib/girepository-1.0 "
            "${python}/bin/python ${checkBackends}'"
        )

    with subtest("CLI-only installation"):
        cli.wait_for_unit("NetworkManager.service")
        cli.fail("systemctl cat me.proton.vpn.split_tunneling.service")
        cli.fail("test -e /etc/NetworkManager/VPN/nm-protun.name")
        cli.fail("test -e /etc/dbus-1/system.d/me.proton.vpn.split_tunneling.conf")
        cli.fail("test -e /run/current-system/sw/bin/protonvpn-app")
        cli.succeed("install -d -o alice -m 700 /run/user/1000")
        cli.succeed("su - alice -c 'XDG_RUNTIME_DIR=/run/user/1000 protonvpn --help'")
  '';
}
