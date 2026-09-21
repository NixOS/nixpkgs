{ ... }:
{
  name = "nebula";

  nodes = {
    lighthouse =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.nebula ];

        services.nebula.networks.smoke = {
          # Note that these paths won't exist when the machine is first booted.
          ca = "/etc/nebula/ca.crt";
          cert = "/etc/nebula/lighthouse.crt";
          key = "/etc/nebula/lighthouse.key";
          isLighthouse = true;
          listen = {
            host = "0.0.0.0";
            port = 4242;
          };
          # A lighthouse can run without a tun interface. The device name is
          # unused then, so the length assertion must not apply to it.
          tun.disable = true;
        };
      };
  };

  testScript = ''
    # Create the certificate and sign the lighthouse's keys.
    lighthouse.succeed(
        "mkdir -p /etc/nebula",
        'nebula-cert ca -duration $((10*365*24*60))m -name "Smoke Test" -out-crt /etc/nebula/ca.crt -out-key /etc/nebula/ca.key',
        'nebula-cert sign -duration $((365*24*60))m -ca-crt /etc/nebula/ca.crt -ca-key /etc/nebula/ca.key -name "lighthouse" -groups "lighthouse" -networks "10.0.100.1/24" -out-crt /etc/nebula/lighthouse.crt -out-key /etc/nebula/lighthouse.key',
        'chown -R nebula-smoke:nebula-smoke /etc/nebula'
    )

    # Restart nebula to pick up the keys and verify it listens without creating a tun device.
    lighthouse.systemctl("restart nebula@smoke.service")
    lighthouse.wait_for_unit("nebula@smoke.service")
    lighthouse.wait_until_succeeds("ss -lun | grep -q ':4242'", timeout=10)
    lighthouse.fail("ip link show nebula.smoke")
  '';
}
