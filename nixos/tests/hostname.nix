{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  makeHostNameTest =
    hostName: domain: fqdnOrNull:
    let
      fqdn = hostName + (optionalString (domain != null) ".${domain}");
      getStr =
        str: # maybeString2String
        let
          res = builtins.tryEval str;
        in
        if (res.success && res.value != null) then res.value else "null";
    in
    makeTest {
      name = "hostname-${fqdn}";
      meta = with pkgs.lib.maintainers; {
        maintainers = [
          blitz
        ];
      };

      nodes.machine =
        { lib, ... }:
        {
          networking.hostName = hostName;
          networking.domain = domain;

          environment.systemPackages = with pkgs; [
            inetutils
          ];
        };

      testScript =
        { nodes, ... }:
        ''
          start_all()

          machine = ${hostName}

          machine.systemctl("start network-online.target")
          machine.wait_for_unit("network-online.target")

          # Test if NixOS computes the correct FQDN (either a FQDN or an error/null):
          assert "${getStr nodes.machine.networking.fqdn}" == "${getStr fqdnOrNull}"

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

          assert "${fqdn}" == machine.succeed("getent hosts ${hostName} | awk '{print $2}'").strip()
        '';
    };

in
{
  noExplicitDomain = makeHostNameTest "ahost" null null;

  explicitDomain = makeHostNameTest "ahost" "adomain" "ahost.adomain";
}
