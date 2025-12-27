{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  makeHostNameTest =
    hostName: domain: explicitFqdn: expectedFqdn:
    let
      fqdn =
        if expectedFqdn != null then
          expectedFqdn
        else
          hostName + (optionalString (domain != null) ".${domain}");
      expectedDomain =
        if hasInfix "." fqdn then concatStringsSep "." (drop 1 (splitString "." fqdn)) else null;

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
          networking = {
            hostName = hostName;
            domain = domain;
          }
          // lib.optionalAttrs (explicitFqdn != null) {
            fqdn = explicitFqdn;
          };

          environment.systemPackages = with pkgs; [
            inetutils
          ];
        };

      testScript =
        { nodes, ... }:
        ''
          start_all()

          machine.systemctl("start network-online.target")
          machine.wait_for_unit("network-online.target")

          # Test if NixOS computes the correct FQDN (either an FQDN or an error/null):
          assert "${getStr nodes.machine.networking.fqdn}" == "${getStr expectedFqdn}"

          # The FQDN, domain name, and hostname detection should work as expected:
          assert "${fqdn}" == machine.succeed("hostname --fqdn").strip()
          domain = "${optionalString (expectedDomain != null) expectedDomain}"
          assert domain == machine.succeed("dnsdomainname").strip()
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
          fqdn_and_host_name = "${optionalString (fqdn != hostName) "${fqdn} "}${hostName}"
          assert (
              fqdn_and_host_name
              == machine.succeed("getent hosts 127.0.0.2 | awk '{print $2,$3}'").strip()
          )

          assert "${fqdn}" == machine.succeed("getent hosts ${hostName} | awk '{print $2}'").strip()
        '';
    };

in
{
  hostNameOnly = makeHostNameTest "ahost" null null null;

  explicitDomain = makeHostNameTest "ahost" "adomain" null "ahost.adomain";

  explicitFqdn = makeHostNameTest "ahost" "domain1" "ahost.domain2" "ahost.domain2";

  fqdnHostName = makeHostNameTest "ahost.adomain" null null "ahost.adomain";

  fqdnHostNameExplicitFqdn = makeHostNameTest "ahost.domain1" null "ahost.domain2" "ahost.domain2";
}
