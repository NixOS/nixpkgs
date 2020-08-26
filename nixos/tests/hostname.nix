{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  makeHostNameTest = hostName: domain:
    let
      fqdn = hostName + (optionalString (domain != null) ".${domain}");
    in
      makeTest {
        name = "hostname-${fqdn}";
        meta = with pkgs.stdenv.lib.maintainers; {
          maintainers = [ primeos blitz ];
        };

        machine = { lib, ... }: {
          networking.hostName = hostName;
          networking.domain = domain;

          environment.systemPackages = with pkgs; [
            inetutils
          ];
        };

        testScript = ''
          start_all()

          machine = ${hostName}

          machine.wait_for_unit("network-online.target")

          # The FQDN, domain name, and hostname detection should work as expected:
          assert "${fqdn}" == machine.succeed("hostname --fqdn").strip()
          assert "${optionalString (domain != null) domain}" == machine.succeed("dnsdomainname").strip()
          assert (
              "${hostName}"
              == machine.succeed(
                  'hostnamectl status | grep "Static hostname" | cut -d: -f2'
              ).strip()
          )

          # 127.0.0.1 and ::1 should resolve back to "localhost":
          assert (
              "localhost" == machine.succeed("getent hosts 127.0.0.1 | awk '{print $2}'").strip()
          )
          assert "localhost" == machine.succeed("getent hosts ::1 | awk '{print $2}'").strip()

          # 127.0.0.2 should resolve back to the FQDN and hostname:
          fqdn_and_host_name = "${optionalString (domain != null) "${hostName}.${domain} "}${hostName}"
          assert (
              fqdn_and_host_name
              == machine.succeed("getent hosts 127.0.0.2 | awk '{print $2,$3}'").strip()
          )
        '';
      };

in
{
  noExplicitDomain = makeHostNameTest "ahost" null;

  explicitDomain = makeHostNameTest "ahost" "adomain";
}
