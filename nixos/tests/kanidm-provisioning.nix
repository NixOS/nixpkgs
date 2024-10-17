import ./make-test-python.nix (
  { pkgs, ... }:
  let
    certs = import ./common/acme/server/snakeoil-certs.nix;
    serverDomain = certs.domain;

    # copy certs to store to work around mount namespacing
    certsPath = pkgs.runCommandNoCC "snakeoil-certs" { } ''
      mkdir $out
      cp ${certs."${serverDomain}".cert} $out/snakeoil.crt
      cp ${certs."${serverDomain}".key} $out/snakeoil.key
    '';

    provisionAdminPassword = "very-strong-password-for-admin";
    provisionIdmAdminPassword = "very-strong-password-for-idm-admin";
    provisionIdmAdminPassword2 = "very-strong-alternative-password-for-idm-admin";
  in
  {
    name = "kanidm-provisioning";
    meta.maintainers = with pkgs.lib.maintainers; [ oddlama ];

    nodes.provision =
      { pkgs, lib, ... }:
      {
        services.kanidm = {
          package = pkgs.kanidm.withSecretProvisioning;
          enableServer = true;
          serverSettings = {
            origin = "https://${serverDomain}";
            domain = serverDomain;
            bindaddress = "[::]:443";
            ldapbindaddress = "[::1]:636";
            tls_chain = "${certsPath}/snakeoil.crt";
            tls_key = "${certsPath}/snakeoil.key";
          };
          # So we can check whether provisioning did what we wanted
          enableClient = true;
          clientSettings = {
            uri = "https://${serverDomain}";
            verify_ca = true;
            verify_hostnames = true;
          };
        };

        specialisation.credentialProvision.configuration =
          { ... }:
          {
            services.kanidm.provision = lib.mkForce {
              enable = true;
              adminPasswordFile = pkgs.writeText "admin-pw" provisionAdminPassword;
              idmAdminPasswordFile = pkgs.writeText "idm-admin-pw" provisionIdmAdminPassword;
            };
          };

        specialisation.changedCredential.configuration =
          { ... }:
          {
            services.kanidm.provision = lib.mkForce {
              enable = true;
              idmAdminPasswordFile = pkgs.writeText "idm-admin-pw" provisionIdmAdminPassword2;
            };
          };

        specialisation.addEntities.configuration =
          { ... }:
          {
            services.kanidm.provision = lib.mkForce {
              enable = true;
              # Test whether credential recovery works without specific idmAdmin password
              #idmAdminPasswordFile =

              groups.supergroup1 = {
                members = [ "testgroup1" ];
              };

              groups.testgroup1 = { };

              persons.testuser1 = {
                displayName = "Test User";
                legalName = "Jane Doe";
                mailAddresses = [ "jane.doe@example.com" ];
                groups = [
                  "testgroup1"
                  "service1-access"
                ];
              };

              persons.testuser2 = {
                displayName = "Powerful Test User";
                legalName = "Ryouiki Tenkai";
                groups = [ "service1-admin" ];
              };

              groups.service1-access = { };
              groups.service1-admin = { };
              systems.oauth2.service1 = {
                displayName = "Service One";
                originUrl = "https://one.example.com/";
                originLanding = "https://one.example.com/landing";
                basicSecretFile = pkgs.writeText "bs-service1" "very-strong-secret-for-service1";
                scopeMaps.service1-access = [
                  "openid"
                  "email"
                  "profile"
                ];
                supplementaryScopeMaps.service1-admin = [ "admin" ];
                claimMaps.groups = {
                  valuesByGroup.service1-admin = [ "admin" ];
                };
              };

              systems.oauth2.service2 = {
                displayName = "Service Two";
                originUrl = "https://two.example.com/";
                originLanding = "https://landing2.example.com/";
                # Test not setting secret
                # basicSecretFile =
                allowInsecureClientDisablePkce = true;
                preferShortUsername = true;
              };
            };
          };

        specialisation.changeAttributes.configuration =
          { ... }:
          {
            services.kanidm.provision = lib.mkForce {
              enable = true;
              # Changing admin credentials at any time should not be a problem:
              idmAdminPasswordFile = pkgs.writeText "idm-admin-pw" provisionIdmAdminPassword;

              groups.supergroup1 = {
                #members = ["testgroup1"];
              };

              groups.testgroup1 = { };

              persons.testuser1 = {
                displayName = "Test User (changed)";
                legalName = "Jane Doe (changed)";
                mailAddresses = [
                  "jane.doe@example.com"
                  "second.doe@example.com"
                ];
                groups = [
                  #"testgroup1"
                  "service1-access"
                ];
              };

              persons.testuser2 = {
                displayName = "Powerful Test User (changed)";
                legalName = "Ryouiki Tenkai (changed)";
                groups = [ "service1-admin" ];
              };

              groups.service1-access = { };
              groups.service1-admin = { };
              systems.oauth2.service1 = {
                displayName = "Service One (changed)";
                # multiple origin urls
                originUrl = [
                  "https://changed-one.example.com/"
                  "https://changed-one.example.org/"
                ];
                originLanding = "https://changed-one.example.com/landing-changed";
                basicSecretFile = pkgs.writeText "bs-service1" "changed-very-strong-secret-for-service1";
                scopeMaps.service1-access = [
                  "openid"
                  "email"
                  #"profile"
                ];
                supplementaryScopeMaps.service1-admin = [ "adminchanged" ];
                claimMaps.groups = {
                  valuesByGroup.service1-admin = [ "adminchanged" ];
                };
              };

              systems.oauth2.service2 = {
                displayName = "Service Two (changed)";
                originUrl = "https://changed-two.example.com/";
                originLanding = "https://changed-landing2.example.com/";
                # Test not setting secret
                # basicSecretFile =
                allowInsecureClientDisablePkce = false;
                preferShortUsername = false;
              };
            };
          };

        specialisation.removeAttributes.configuration =
          { ... }:
          {
            services.kanidm.provision = lib.mkForce {
              enable = true;
              idmAdminPasswordFile = pkgs.writeText "idm-admin-pw" provisionIdmAdminPassword;

              groups.supergroup1 = { };

              persons.testuser1 = {
                displayName = "Test User (changed)";
              };

              persons.testuser2 = {
                displayName = "Powerful Test User (changed)";
                groups = [ "service1-admin" ];
              };

              groups.service1-access = { };
              groups.service1-admin = { };
              systems.oauth2.service1 = {
                displayName = "Service One (changed)";
                originUrl = "https://changed-one.example.com/";
                originLanding = "https://changed-one.example.com/landing-changed";
                basicSecretFile = pkgs.writeText "bs-service1" "changed-very-strong-secret-for-service1";
                # Removing maps requires setting them to the empty list
                scopeMaps.service1-access = [ ];
                supplementaryScopeMaps.service1-admin = [ ];
              };

              systems.oauth2.service2 = {
                displayName = "Service Two (changed)";
                originUrl = "https://changed-two.example.com/";
                originLanding = "https://changed-landing2.example.com/";
              };
            };
          };

        specialisation.removeEntities.configuration =
          { ... }:
          {
            services.kanidm.provision = lib.mkForce {
              enable = true;
              idmAdminPasswordFile = pkgs.writeText "idm-admin-pw" provisionIdmAdminPassword;
            };
          };

        security.pki.certificateFiles = [ certs.ca.cert ];

        networking.hosts."::1" = [ serverDomain ];
        networking.firewall.allowedTCPPorts = [ 443 ];

        users.users.kanidm.shell = pkgs.bashInteractive;

        environment.systemPackages = with pkgs; [
          kanidm
          openldap
          ripgrep
          jq
        ];
      };

    testScript =
      { nodes, ... }:
      let
        # We need access to the config file in the test script.
        filteredConfig = pkgs.lib.converge (pkgs.lib.filterAttrsRecursive (
          _: v: v != null
        )) nodes.provision.services.kanidm.serverSettings;
        serverConfigFile = (pkgs.formats.toml { }).generate "server.toml" filteredConfig;

        specialisations = "${nodes.provision.system.build.toplevel}/specialisation";
      in
      ''
        import re

        def assert_contains(haystack, needle):
            if needle not in haystack:
                print("The haystack that will cause the following exception is:")
                print("---")
                print(haystack)
                print("---")
                raise Exception(f"Expected string '{needle}' was not found")

        def assert_matches(haystack, expr):
            if not re.search(expr, haystack):
                print("The haystack that will cause the following exception is:")
                print("---")
                print(haystack)
                print("---")
                raise Exception(f"Expected regex '{expr}' did not match")

        def assert_lacks(haystack, needle):
            if needle in haystack:
                print("The haystack that will cause the following exception is:")
                print("---")
                print(haystack, end="")
                print("---")
                raise Exception(f"Unexpected string '{needle}' was found")

        provision.start()

        def provision_login(pw):
            provision.wait_for_unit("kanidm.service")
            provision.wait_until_succeeds("curl -Lsf https://${serverDomain} | grep Kanidm")
            if pw is None:
                pw = provision.succeed("su - kanidm -c 'kanidmd recover-account -c ${serverConfigFile} idm_admin 2>&1 | rg -o \'[A-Za-z0-9]{48}\' '").strip().removeprefix("'").removesuffix("'")
            out = provision.succeed(f"KANIDM_PASSWORD={pw} kanidm login -D idm_admin")
            assert_contains(out, "Login Success for idm_admin")

        with subtest("Test Provisioning - setup"):
            provision_login(None)
            provision.succeed("kanidm logout -D idm_admin")

        with subtest("Test Provisioning - credentialProvision"):
            provision.succeed('${specialisations}/credentialProvision/bin/switch-to-configuration test')
            provision_login("${provisionIdmAdminPassword}")

            # Test provisioned admin pw
            out = provision.succeed("KANIDM_PASSWORD=${provisionAdminPassword} kanidm login -D admin")
            assert_contains(out, "Login Success for admin")
            provision.succeed("kanidm logout -D admin")
            provision.succeed("kanidm logout -D idm_admin")

        with subtest("Test Provisioning - changedCredential"):
            provision.succeed('${specialisations}/changedCredential/bin/switch-to-configuration test')
            provision_login("${provisionIdmAdminPassword2}")
            provision.succeed("kanidm logout -D idm_admin")

        with subtest("Test Provisioning - addEntities"):
            provision.succeed('${specialisations}/addEntities/bin/switch-to-configuration test')
            # Unspecified idm admin password
            provision_login(None)

            out = provision.succeed("kanidm group get testgroup1")
            assert_contains(out, "name: testgroup1")

            out = provision.succeed("kanidm group get supergroup1")
            assert_contains(out, "name: supergroup1")
            assert_contains(out, "member: testgroup1")

            out = provision.succeed("kanidm person get testuser1")
            assert_contains(out, "name: testuser1")
            assert_contains(out, "displayname: Test User")
            assert_contains(out, "legalname: Jane Doe")
            assert_contains(out, "mail: jane.doe@example.com")
            assert_contains(out, "memberof: testgroup1")
            assert_contains(out, "memberof: service1-access")

            out = provision.succeed("kanidm person get testuser2")
            assert_contains(out, "name: testuser2")
            assert_contains(out, "displayname: Powerful Test User")
            assert_contains(out, "legalname: Ryouiki Tenkai")
            assert_contains(out, "memberof: service1-admin")
            assert_lacks(out, "mail:")

            out = provision.succeed("kanidm group get service1-access")
            assert_contains(out, "name: service1-access")

            out = provision.succeed("kanidm group get service1-admin")
            assert_contains(out, "name: service1-admin")

            out = provision.succeed("kanidm system oauth2 get service1")
            assert_contains(out, "name: service1")
            assert_contains(out, "displayname: Service One")
            assert_contains(out, "oauth2_rs_origin: https://one.example.com/")
            assert_contains(out, "oauth2_rs_origin_landing: https://one.example.com/landing")
            assert_matches(out, 'oauth2_rs_scope_map: service1-access.*{"email", "openid", "profile"}')
            assert_matches(out, 'oauth2_rs_sup_scope_map: service1-admin.*{"admin"}')
            assert_matches(out, 'oauth2_rs_claim_map: groups:.*"admin"')

            out = provision.succeed("kanidm system oauth2 show-basic-secret service1")
            assert_contains(out, "very-strong-secret-for-service1")

            out = provision.succeed("kanidm system oauth2 get service2")
            assert_contains(out, "name: service2")
            assert_contains(out, "displayname: Service Two")
            assert_contains(out, "oauth2_rs_origin: https://two.example.com/")
            assert_contains(out, "oauth2_rs_origin_landing: https://landing2.example.com/")
            assert_contains(out, "oauth2_allow_insecure_client_disable_pkce: true")
            assert_contains(out, "oauth2_prefer_short_username: true")

            provision.succeed("kanidm logout -D idm_admin")

        with subtest("Test Provisioning - changeAttributes"):
            provision.succeed('${specialisations}/changeAttributes/bin/switch-to-configuration test')
            provision_login("${provisionIdmAdminPassword}")

            out = provision.succeed("kanidm group get testgroup1")
            assert_contains(out, "name: testgroup1")

            out = provision.succeed("kanidm group get supergroup1")
            assert_contains(out, "name: supergroup1")
            assert_lacks(out, "member: testgroup1")

            out = provision.succeed("kanidm person get testuser1")
            assert_contains(out, "name: testuser1")
            assert_contains(out, "displayname: Test User (changed)")
            assert_contains(out, "legalname: Jane Doe (changed)")
            assert_contains(out, "mail: jane.doe@example.com")
            assert_contains(out, "mail: second.doe@example.com")
            assert_lacks(out, "memberof: testgroup1")
            assert_contains(out, "memberof: service1-access")

            out = provision.succeed("kanidm person get testuser2")
            assert_contains(out, "name: testuser2")
            assert_contains(out, "displayname: Powerful Test User (changed)")
            assert_contains(out, "legalname: Ryouiki Tenkai (changed)")
            assert_contains(out, "memberof: service1-admin")
            assert_lacks(out, "mail:")

            out = provision.succeed("kanidm group get service1-access")
            assert_contains(out, "name: service1-access")

            out = provision.succeed("kanidm group get service1-admin")
            assert_contains(out, "name: service1-admin")

            out = provision.succeed("kanidm system oauth2 get service1")
            assert_contains(out, "name: service1")
            assert_contains(out, "displayname: Service One (changed)")
            assert_contains(out, "oauth2_rs_origin: https://changed-one.example.com/")
            assert_contains(out, "oauth2_rs_origin: https://changed-one.example.org/")
            assert_contains(out, "oauth2_rs_origin_landing: https://changed-one.example.com/landing")
            assert_matches(out, 'oauth2_rs_scope_map: service1-access.*{"email", "openid"}')
            assert_matches(out, 'oauth2_rs_sup_scope_map: service1-admin.*{"adminchanged"}')
            assert_matches(out, 'oauth2_rs_claim_map: groups:.*"adminchanged"')

            out = provision.succeed("kanidm system oauth2 show-basic-secret service1")
            assert_contains(out, "changed-very-strong-secret-for-service1")

            out = provision.succeed("kanidm system oauth2 get service2")
            assert_contains(out, "name: service2")
            assert_contains(out, "displayname: Service Two (changed)")
            assert_contains(out, "oauth2_rs_origin: https://changed-two.example.com/")
            assert_contains(out, "oauth2_rs_origin_landing: https://changed-landing2.example.com/")
            assert_lacks(out, "oauth2_allow_insecure_client_disable_pkce: true")
            assert_lacks(out, "oauth2_prefer_short_username: true")

            provision.succeed("kanidm logout -D idm_admin")

        with subtest("Test Provisioning - removeAttributes"):
            provision.succeed('${specialisations}/removeAttributes/bin/switch-to-configuration test')
            provision_login("${provisionIdmAdminPassword}")

            out = provision.succeed("kanidm group get testgroup1")
            assert_lacks(out, "name: testgroup1")

            out = provision.succeed("kanidm group get supergroup1")
            assert_contains(out, "name: supergroup1")
            assert_lacks(out, "member: testgroup1")

            out = provision.succeed("kanidm person get testuser1")
            assert_contains(out, "name: testuser1")
            assert_contains(out, "displayname: Test User (changed)")
            assert_lacks(out, "legalname: Jane Doe (changed)")
            assert_lacks(out, "mail: jane.doe@example.com")
            assert_lacks(out, "mail: second.doe@example.com")
            assert_lacks(out, "memberof: testgroup1")
            assert_lacks(out, "memberof: service1-access")

            out = provision.succeed("kanidm person get testuser2")
            assert_contains(out, "name: testuser2")
            assert_contains(out, "displayname: Powerful Test User (changed)")
            assert_lacks(out, "legalname: Ryouiki Tenkai (changed)")
            assert_contains(out, "memberof: service1-admin")
            assert_lacks(out, "mail:")

            out = provision.succeed("kanidm group get service1-access")
            assert_contains(out, "name: service1-access")

            out = provision.succeed("kanidm group get service1-admin")
            assert_contains(out, "name: service1-admin")

            out = provision.succeed("kanidm system oauth2 get service1")
            assert_contains(out, "name: service1")
            assert_contains(out, "displayname: Service One (changed)")
            assert_contains(out, "oauth2_rs_origin: https://changed-one.example.com/")
            assert_lacks(out, "oauth2_rs_origin: https://changed-one.example.org/")
            assert_contains(out, "oauth2_rs_origin_landing: https://changed-one.example.com/landing")
            assert_lacks(out, "oauth2_rs_scope_map")
            assert_lacks(out, "oauth2_rs_sup_scope_map")
            assert_lacks(out, "oauth2_rs_claim_map")

            out = provision.succeed("kanidm system oauth2 show-basic-secret service1")
            assert_contains(out, "changed-very-strong-secret-for-service1")

            out = provision.succeed("kanidm system oauth2 get service2")
            assert_contains(out, "name: service2")
            assert_contains(out, "displayname: Service Two (changed)")
            assert_contains(out, "oauth2_rs_origin: https://changed-two.example.com/")
            assert_contains(out, "oauth2_rs_origin_landing: https://changed-landing2.example.com/")
            assert_lacks(out, "oauth2_allow_insecure_client_disable_pkce: true")
            assert_lacks(out, "oauth2_prefer_short_username: true")

            provision.succeed("kanidm logout -D idm_admin")

        with subtest("Test Provisioning - removeEntities"):
            provision.succeed('${specialisations}/removeEntities/bin/switch-to-configuration test')
            provision_login("${provisionIdmAdminPassword}")

            out = provision.succeed("kanidm group get testgroup1")
            assert_lacks(out, "name: testgroup1")

            out = provision.succeed("kanidm group get supergroup1")
            assert_lacks(out, "name: supergroup1")

            out = provision.succeed("kanidm person get testuser1")
            assert_lacks(out, "name: testuser1")

            out = provision.succeed("kanidm person get testuser2")
            assert_lacks(out, "name: testuser2")

            out = provision.succeed("kanidm group get service1-access")
            assert_lacks(out, "name: service1-access")

            out = provision.succeed("kanidm group get service1-admin")
            assert_lacks(out, "name: service1-admin")

            out = provision.succeed("kanidm system oauth2 get service1")
            assert_lacks(out, "name: service1")

            out = provision.succeed("kanidm system oauth2 get service2")
            assert_lacks(out, "name: service2")

            provision.succeed("kanidm logout -D idm_admin")
      '';
  }
)
