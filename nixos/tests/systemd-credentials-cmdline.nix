{ ... }:
{
  name = "systemd-credentials-cmdline";

  nodes.machine =
    { pkgs, ... }:
    {
      boot.kernelParams = [ "systemd.set_credential=foo.bar:baz" ];
      boot.initrd.systemd.enable = true;
      systemd.services.read-credential = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ImportCredential = "foo.bar";
          ExecStart = [ "${pkgs.coreutils}/bin/cat \${CREDENTIALS_DIRECTORY}/foo.bar" ];
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("read-credential.service")
  '';
}
