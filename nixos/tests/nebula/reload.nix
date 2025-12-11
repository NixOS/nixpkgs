{ pkgs, lib, ... }:
let

  inherit (import ../ssh-keys.nix pkgs)
    snakeOilPrivateKey
    snakeOilPublicKey
    ;

in
{
  name = "nebula";

  nodes = {
    lighthouse =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        environment.systemPackages = [ pkgs.nebula ];
        environment.etc."nebula-key" = {
          user = "nebula-smoke";
          group = "nebula-smoke";
          source = snakeOilPrivateKey;
          mode = "0600";
        };

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
          enableReload = true;
          settings.sshd = {
            enabled = true;
            listen = "127.0.0.1:2222";
            host_key = "/etc/nebula-key";
          };
        };

        # We will test that nebula is reloaded by switching specialisations.
        specialisation.sshd-off.configuration = {
          services.nebula.networks.smoke.settings.sshd.enabled = lib.mkForce false;
        };
        specialisation.sshd-on.configuration = {
          services.nebula.networks.smoke.settings.sshd.enabled = lib.mkForce true;
        };
      };
  };

  testScript =
    { nodes, ... }:
    let
      sshd-on = "${nodes.lighthouse.system.build.toplevel}/specialisation/sshd-on";
      sshd-off = "${nodes.lighthouse.system.build.toplevel}/specialisation/sshd-off";
    in
    ''
      # Create the certificate and sign the lighthouse's keys.
      lighthouse.succeed(
          "mkdir -p /etc/nebula",
          'nebula-cert ca -duration $((10*365*24*60))m -name "Smoke Test" -out-crt /etc/nebula/ca.crt -out-key /etc/nebula/ca.key',
          'nebula-cert sign -duration $((365*24*60))m -ca-crt /etc/nebula/ca.crt -ca-key /etc/nebula/ca.key -name "lighthouse" -groups "lighthouse" -ip "10.0.100.1/24" -out-crt /etc/nebula/lighthouse.crt -out-key /etc/nebula/lighthouse.key',
          'chown -R nebula-smoke:nebula-smoke /etc/nebula'
      )

      # Restart nebula to pick up the keys.
      lighthouse.systemctl("restart nebula@smoke.service")
      lighthouse.succeed("ping -c5 10.0.100.1")

      # Verify that nebula's ssh interface is up.
      lighthouse.succeed("${pkgs.nmap}/bin/nmap 127.0.0.1 | grep 2222/tcp")

      # Switch configuration, verify nebula was reloaded and not restarted.
      lighthouse.succeed("${sshd-off}/bin/switch-to-configuration test 2>&1 | grep 'nebula' | grep 'reload'")

      # Verify that nebula's ssh interface is no longer up.
      lighthouse.fail("${pkgs.nmap}/bin/nmap 127.0.0.1 | grep 2222/tcp")

      # Switch configuration, verify reload again.
      lighthouse.succeed("${sshd-on}/bin/switch-to-configuration test 2>&1 | grep 'nebula' | grep 'reload'")

      # Verify that ssh is back.
      lighthouse.succeed("${pkgs.nmap}/bin/nmap 127.0.0.1 | grep 2222/tcp")
    '';
}
