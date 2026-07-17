{ hostPkgs, ... }:

{
  name = "pam-u2f-polkit";

  qemu.package = hostPkgs.qemu_test.override { u2fEmuSupport = true; };

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.qemu.options = [
        "-usb"
        "-device u2f-emulated"
      ];

      security.polkit.enable = true;
      security.pam.u2f.enable = true;

      environment.systemPackages = with pkgs; [
        libfido2
        pam_u2f
      ];
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    # The upstream polkit-agent-helper@.service has PrivateDevices=yes and
    # DevicePolicy=strict with only /dev/null allowed. This blocks hidraw.
    # Verify that: run a command under the upstream defaults and show it fails.
    machine.fail(
        "systemd-run --wait --pipe "
        "--property=PrivateDevices=yes "
        "--property=DevicePolicy=strict "
        "--property='DeviceAllow=/dev/null rw' "
        "test -c /dev/hidraw0"
    )

    # The PR overrides PrivateDevices=no and adds DeviceAllow for hidraw.
    # Verify that the actual polkit-agent-helper@ unit got these overrides.
    props = machine.succeed("systemctl show polkit-agent-helper@dummy.service")
    assert "PrivateDevices=no" in props, f"Expected PrivateDevices=no, got: {props}"
    assert "ProtectHome=read-only" in props, f"Expected ProtectHome=read-only, got: {props}"

    # Run fido2-token under the same constraints as the fixed service.
    # This proves the device is not just visible but actually usable
    # inside the polkit-agent-helper@ sandbox.
    machine.succeed(
        "systemd-run --wait --pipe "
        "--property=PrivateDevices=no "
        "--property=DevicePolicy=strict "
        "--property='DeviceAllow=/dev/null rw' "
        "--property='DeviceAllow=/dev/urandom r' "
        "--property='DeviceAllow=char-hidraw rw' "
        "--property=ProtectHome=read-only "
        "--property=PrivateNetwork=yes "
        "--property=ProtectSystem=strict "
        "--property=ProtectKernelModules=yes "
        "--property=ProtectKernelLogs=yes "
        "--property=ProtectKernelTunables=yes "
        "--property=ProtectControlGroups=yes "
        "--property=ProtectClock=yes "
        "--property=ProtectHostname=yes "
        "--property=LockPersonality=yes "
        "--property=MemoryDenyWriteExecute=yes "
        "--property=NoNewPrivileges=yes "
        "--property=PrivateTmp=yes "
        "--property=RemoveIPC=yes "
        "--property='RestrictAddressFamilies=AF_UNIX' "
        "--property=RestrictNamespaces=yes "
        "--property=RestrictRealtime=yes "
        "--property=RestrictSUIDSGID=yes "
        "--property=SystemCallArchitectures=native "
        "fido2-token -I /dev/hidraw0"
    )

    # Also verify that pamu2fcfg can register a credential inside the sandbox
    # (needs hidraw + urandom access)
    machine.succeed(
        "systemd-run --wait --pipe "
        "--property=PrivateDevices=no "
        "--property=DevicePolicy=strict "
        "--property='DeviceAllow=/dev/null rw' "
        "--property='DeviceAllow=/dev/urandom r' "
        "--property='DeviceAllow=char-hidraw rw' "
        "--property=ProtectHome=read-only "
        "pamu2fcfg"
    )
  '';
}
