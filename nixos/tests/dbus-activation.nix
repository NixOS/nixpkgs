# D-Bus services added or removed by a switch must take effect without a manual reload.
{ lib, pkgs, ... }:
let
  mkServices =
    name:
    let
      busName = "org.nixos.Test${name}";
      exec = bus: "${pkgs.dbus.out}/bin/dbus-test-tool echo --${bus} --name=${busName}";
    in
    pkgs.runCommand "dbus-activation-test-${name}" { } ''
      mkdir -p $out/share/dbus-1/services $out/share/dbus-1/system-services $out/etc/dbus-1/system.d

      cat > $out/share/dbus-1/services/${busName}.service <<EOF
      [D-BUS Service]
      Name=${busName}
      Exec=${exec "session"}
      EOF

      cat > $out/share/dbus-1/system-services/${busName}.service <<EOF
      [D-BUS Service]
      Name=${busName}
      Exec=${exec "system"}
      User=root
      EOF

      cat > $out/etc/dbus-1/system.d/${busName}.conf <<EOF
      <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
       "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
      <busconfig>
        <policy user="root">
          <allow own="${busName}"/>
        </policy>
        <policy context="default">
          <allow send_destination="${busName}"/>
        </policy>
      </busconfig>
      EOF
    '';

  mkNode = implementation: {
    services.dbus.implementation = implementation;

    # Without other user units, share/systemd/user in system.path links to
    # dbus-broker, and the switch skips the user unit loaded from there.
    environment.systemPackages = [
      (pkgs.runCommand "extra-user-unit" { } ''
        mkdir -p $out/share/systemd/user
        printf '[Service]\nExecStart=/bin/sh -c true\n' > $out/share/systemd/user/extra.service
      '')
    ];

    users.users.alice = {
      isNormalUser = true;
      linger = true;
    };

    specialisation.installed.configuration = {
      environment.systemPackages = [ (mkServices "Installed") ];
    };
    specialisation.registered.configuration = {
      services.dbus.packages = [ (mkServices "Registered") ];
    };
  };
in
{
  name = "dbus-activation";

  meta.maintainers = with lib.maintainers; [ rvdp ];

  nodes = {
    dbus = mkNode "dbus";
    broker = mkNode "broker";
  };

  testScript = ''
    def send(machine, bus, args):
        cmd = f"timeout 15 dbus-send --{bus} --print-reply {args}"
        if bus == "session":
            cmd = (
                "runuser -u alice -- env XDG_RUNTIME_DIR=/run/user/1000 "
                "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus " + cmd
            )
        return machine.succeed(cmd)

    def ping(machine, bus, name):
        send(machine, bus, f"--dest=org.nixos.Test{name} / org.freedesktop.DBus.Peer.Ping")

    # A ping still succeeds after removal, since the activated service keeps running.
    def activatable(machine, bus, name):
        names = send(
            machine,
            bus,
            "--dest=org.freedesktop.DBus /org/freedesktop/DBus "
            "org.freedesktop.DBus.ListActivatableNames",
        )
        return f'"org.nixos.Test{name}"' in names

    def check(machine, spec, name):
        with subtest(f"{machine.name}: services of the {spec} package"):
            machine.succeed(
                f"/run/booted-system/specialisation/{spec}/bin/switch-to-configuration test"
            )
            for bus in ["system", "session"]:
                assert activatable(machine, bus, name), f"{name} not activatable on {bus} bus"
                ping(machine, bus, name)
            machine.succeed("/run/booted-system/bin/switch-to-configuration test")
            for bus in ["system", "session"]:
                assert not activatable(machine, bus, name), (
                    f"{name} still activatable on {bus} bus after removal"
                )

    start_all()
    for machine in [dbus, broker]:
        machine.wait_for_unit("user@1000.service")
        # Otherwise the switch starts it with the new config.
        machine.succeed("systemctl --user -M alice@ start dbus.socket dbus.service")
        check(machine, "installed", "Installed")
        check(machine, "registered", "Registered")
  '';
}
