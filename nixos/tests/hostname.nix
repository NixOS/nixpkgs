{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
  inherit (pkgs.lib) optionalString;
  makeHostNameTest = hostName: domain: fqdnOrNull:
    let
      fqdn = hostName + (optionalString (domain != null) ".${domain}");
      getStr = str: # maybeString2String
        let res = builtins.tryEval str;
        in if (res.success && res.value != null) then res.value else "null";
    in
    makeTest {
      name = "hostname-${fqdn}";
      meta = with pkgs.lib.maintainers; {
        maintainers = [ primeos blitz ];
      };

      nodes.machine = { lib, ... }: {
        networking.hostName = hostName;
        networking.domain = domain;

        environment.systemPackages = with pkgs; [
          inetutils
        ];
      };

      testScript = { nodes, ... }: ''
        start_all()

        machine = ${hostName}

        machine.wait_for_unit("network-online.target")

        # Test if NixOS computes the correct FQDN (either a FQDN or an error/null):
        assert "${getStr nodes.machine.networking.fqdn}" == "${getStr fqdnOrNull}"

        emptyDomainNamePlaceholder="(none)"

        # The FQDN, domain name, and hostname detection should work as expected:
        assert "${hostName}" == machine.succeed("hostname").strip()
        assert "${optionalString (domain != null) domain}" == machine.succeed("domainname").replace(emptyDomainNamePlaceholder, "").strip()

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
        fqdn_or_host = "${hostName}${optionalString (domain != null) ".${domain}"}"
        assert (
            fqdn_or_host
            == machine.succeed("getent hosts 127.0.0.2 | awk '{print $2}'").strip()
        )
      '';
    };
in
{
  noExplicitDomain = makeHostNameTest "ahost" null null;

  explicitDomain = makeHostNameTest "ahost" "adomain" "ahost.adomain";
}
