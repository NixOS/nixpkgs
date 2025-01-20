# This test runs gitlab and performs the following tests:
# - Create a user
# - Create personal access tokens
# - Download the repository
#   - over the API (fetchzip/-url/curl, https)
#   - over Git (fetchgit, https)
#
# Run with
# [nixpkgs]$ nix-build -A nixosTests.gitlab-fetch-private
#
# Based on ./gitlab.nix
{ pkgs, lib, ... }:

let
  initialRootPassword = "notproduction";

  aliceUsername = "alice";
  aliceUserId = "2";
  alicePassword = "XwkkBbl2SiIwabQzgcoaTbhsotijEEtF";
  aliceProjectId = "1";
  aliceProjectName = "test-alice";

  certs = import ./common/acme/server/snakeoil-certs.nix;
  inherit (certs) domain;
  cacert_with_extras = pkgs.cacert.override {
    extraCertificateFiles = [ certs.ca.cert ];
  };
in
{
  name = "gitlab-fetch-private";
  meta.maintainers = with lib.maintainers; [ panicgh ];

  nodes = {
    gitlab =
      { ... }:
      {
        imports = [ common/user-account.nix ];

        virtualisation.memorySize = 6144;
        virtualisation.cores = 4;
        virtualisation.useNixStoreImage = true;
        virtualisation.writableStore = false;

        networking.firewall.allowedTCPPorts = [ 443 ];

        systemd.services.gitlab.serviceConfig.Restart = lib.mkForce "no";
        systemd.services.gitlab-workhorse.serviceConfig.Restart = lib.mkForce "no";
        systemd.services.gitaly.serviceConfig.Restart = lib.mkForce "no";
        systemd.services.gitlab-sidekiq.serviceConfig.Restart = lib.mkForce "no";

        services.nginx = {
          enable = true;
          recommendedProxySettings = true;
          virtualHosts = {
            # for test setup
            localhost = {
              locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
            };

            # for fetchurl and fetchgit from the client VM
            "${domain}" = {
              onlySSL = true;
              sslCertificate = certs."${domain}".cert;
              sslCertificateKey = certs."${domain}".key;
              locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
            };
          };
        };

        services.dovecot2 = {
          enable = true;
          enableImap = true;
        };

        systemd.services.gitlab-backup.environment.BACKUP = "dump";

        services.gitlab = {
          enable = true;
          databasePasswordFile = pkgs.writeText "dbPassword" "xo0daiF4";
          initialRootPasswordFile = pkgs.writeText "rootPassword" initialRootPassword;
          smtp.enable = true;
          extraConfig = {
            incoming_email = {
              enabled = true;
              mailbox = "inbox";
              address = "alice@localhost";
              user = "alice";
              password = "foobar";
              host = "localhost";
              port = 143;
            };
          };
          secrets = {
            secretFile = pkgs.writeText "secret" "Aig5zaic";
            otpFile = pkgs.writeText "otpsecret" "Riew9mue";
            dbFile = pkgs.writeText "dbsecret" "we2quaeZ";
            jwsFile = pkgs.runCommand "oidcKeyBase" { } "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
          };

          # reduce memory usage
          sidekiq.concurrency = 1;
          puma.workers = 2;
        };
      };

    client =
      { nodes, pkgs, ... }:
      {
        imports = [
          common/user-account.nix
          ../modules/installer/cd-dvd/channel.nix
        ];

        virtualisation.memorySize = 512;
        virtualisation.cores = 1;
        virtualisation.useNixStoreImage = true;
        virtualisation.writableStore = true;
        virtualisation.additionalPaths =
          with pkgs;
          map (pkg: writeClosure pkg.drvPath) [
            curl
            gitMinimal
            cacert_with_extras
          ];

        security.pki.certificateFiles = [ certs.ca.cert ];

        networking.extraHosts = ''
          ${(builtins.head nodes.gitlab.networking.interfaces.eth1.ipv4.addresses).address} ${domain}
        '';

        systemd.services.nix-daemon.serviceConfig.EnvironmentFile = "/root/tokens.txt";
      };
  };

  testScript =
    { nodes, ... }:
    let
      auth = pkgs.writeText "auth.json" (
        builtins.toJSON {
          grant_type = "password";
          username = "root";
          password = initialRootPassword;
        }
      );

      createUserAlice = pkgs.writeText "create-user-alice.json" (
        builtins.toJSON rec {
          username = aliceUsername;
          name = username;
          email = "alice@localhost";
          password = alicePassword;
          skip_confirmation = true;
        }
      );

      aliceAuth = pkgs.writeText "alice-auth.json" (
        builtins.toJSON {
          grant_type = "password";
          username = aliceUsername;
          password = alicePassword;
        }
      );

      createProjectAlice = pkgs.writeText "create-project-alice.json" (
        builtins.toJSON {
          name = aliceProjectName;
          visibility = "private";
        }
      );

      putFile = pkgs.writeText "put-file.json" (
        builtins.toJSON {
          branch = "master";
          author_email = "author@example.com";
          author_name = "Firstname Lastname";
          content = "some content";
          commit_message = "create a new file";
        }
      );

      createTokenReadRepo = pkgs.writeText "create-project-token-read-repo.json" (
        builtins.toJSON {
          id = aliceProjectId;
          name = "test_read_repo";
          scopes = [ "read_repository" ];
          access_level = 20; # "Reporter"
          expires_at = null;
        }
      );

      createTokenReadApi = pkgs.writeText "create-project-token-read-api.json" (
        builtins.toJSON {
          id = aliceProjectId;
          name = "test_read_api";
          scopes = [ "read_api" ];
          access_level = 20; # "Reporter"
          expires_at = null;
        }
      );

      # The fetchers don't honor the OS trusted CAs as this would be impure.
      # To make it accept our custom (self-signed) CA, it must be added to cacert.
      #
      # Fetch as if the repo was public. This must fail.
      fetchAsPublic = pkgs.writeText "fetch-as-public.nix" ''
        let
          pkgs = import <nixpkgs> {};
          fetchFromGitLab = pkgs.fetchFromGitLab.override {
            fetchgit = pkgs.fetchgit.override {
              cacert = ${cacert_with_extras};
            };
          };
        in pkgs.invalidateFetcherByDrvHash fetchFromGitLab {
          domain = "${domain}";
          owner = "alice";
          repo = "test-alice";
          rev = "refs/heads/master";
          sha256 = "sha256-HqozwmyEGzXUlSL6zgInlycalxROnD2QOSPRwkrw8sQ=";
        }
      '';

      # The fetchers don't honor the OS trusted CAs as this would be impure.
      # To make it accept our custom (self-signed) CA, it must be added to cacert.
      fetchWithRepoScope = pkgs.writeText "fetch-with-repo-scope.nix" ''
        let
          pkgs = import <nixpkgs> {};
          fetchFromGitLab = pkgs.fetchFromGitLab.override {
            fetchgit = pkgs.fetchgit.override {
              cacert = ${cacert_with_extras};
            };
          };
        in pkgs.invalidateFetcherByDrvHash fetchFromGitLab {
          domain = "${domain}";
          private = true;
          # varPrefix: default, no prefix
          owner = "alice";
          repo = "test-alice";
          rev = "refs/heads/master";
          sha256 = "sha256-HqozwmyEGzXUlSL6zgInlycalxROnD2QOSPRwkrw8sQ=";
          forceFetchGit = true;
        }
      '';

      # The fetchers don't honor the OS trusted CAs as this would be impure.
      # To make it accept our custom (self-signed) CA, it must be added to cacert.
      fetchWithApiScope = pkgs.writeText "fetch-with-api-scope.nix" ''
        let
          pkgs = import <nixpkgs> {};
          fetchFromGitLab = pkgs.fetchFromGitLab.override {
            fetchzip = pkgs.fetchzip.override {
              fetchurl = pkgs.fetchurl.override {
                cacert = ${cacert_with_extras};
              };
            };
          };
        in pkgs.invalidateFetcherByDrvHash fetchFromGitLab {
          domain = "${domain}";
          private = true;
          varPrefix = "MYPREFIX";
          owner = "alice";
          repo = "test-alice";
          rev = "refs/heads/master";
          sha256 = "sha256-XHNNJr5NrfLMnom2ZQkkhmZ/7q8eOc563N4AbyF3K84=";
        }
      '';

      # Wait for all GitLab services to be fully started.
      waitForServices = ''
        gitlab.wait_for_unit("gitaly.service")
        gitlab.wait_for_unit("gitlab-workhorse.service")
        gitlab.wait_for_unit("gitlab-mailroom.service")
        gitlab.wait_for_unit("gitlab.service")
        gitlab.wait_for_unit("gitlab-sidekiq.service")
        gitlab.wait_for_file("${nodes.gitlab.services.gitlab.statePath}/tmp/sockets/gitlab.socket")
        gitlab.wait_until_succeeds("curl -sSf http://gitlab/users/sign_in")
      '';

      # The actual test of GitLab.
      test = ''
        gitlab.succeed(
            "curl -isSf http://gitlab | grep -i location | grep http://gitlab/users/sign_in"
        )
        gitlab.succeed(
            "${pkgs.sudo}/bin/sudo -u gitlab -H gitlab-rake gitlab:check 1>&2"
        )
        gitlab.succeed(
            "echo \"Authorization: Bearer $(curl -X POST -H 'Content-Type: application/json' -d @${auth} http://gitlab/oauth/token | ${pkgs.jq}/bin/jq -r '.access_token')\" >/tmp/headers"
        )

        with subtest("Create user Alice"):
            gitlab.succeed(
                """[ "$(curl -o /dev/null -w '%{http_code}' -X POST -H 'Content-Type: application/json' -H @/tmp/headers -d @${createUserAlice} http://gitlab/api/v4/users)" = "201" ]"""
            )
            gitlab.succeed(
                "echo \"Authorization: Bearer $(curl -X POST -H 'Content-Type: application/json' -d @${aliceAuth} http://gitlab/oauth/token | ${pkgs.jq}/bin/jq -r '.access_token')\" >/tmp/headers-alice"
            )

        with subtest("Create a new repository"):
            # Alice creates a new repository
            gitlab.succeed(
                """
                [ "$(curl \
                    -o /dev/null \
                    -w '%{http_code}' \
                    -X POST \
                    -H 'Content-Type: application/json' \
                    -H @/tmp/headers-alice \
                    -d @${createProjectAlice} \
                    http://gitlab/api/v4/projects)" = "201" ]
                """
            )

            # Alice commits an initial commit
            gitlab.succeed(
                """
                [ "$(curl \
                    -o /dev/null \
                    -w '%{http_code}' \
                    -X POST \
                    -H 'Content-Type: application/json' \
                    -H @/tmp/headers-alice \
                    -d @${putFile} \
                    http://gitlab/api/v4/projects/${aliceProjectId}/repository/files/some-file.txt)" = "201" ]"""
            )

        with subtest("Create read-only access tokens"):
            # Alice creates a project access token
            gitlab.succeed(
                """
                curl \
                  -X POST \
                  -H 'Content-Type: application/json' \
                  -H @/tmp/headers-alice \
                  -d @${createTokenReadRepo} \
                  http://gitlab/api/v4/projects/${aliceProjectId}/access_tokens | \
                    ${pkgs.jq}/bin/jq -r '.token' >/tmp/token-read-repo
                """
            )
            token_read_repo = gitlab.succeed("grep \"^glpat-\" /tmp/token-read-repo").strip()

            # Alice creates another project access token
            gitlab.succeed(
                """
                curl \
                  -X POST \
                  -H 'Content-Type: application/json' \
                  -H @/tmp/headers-alice \
                  -d @${createTokenReadApi} \
                  http://gitlab/api/v4/projects/${aliceProjectId}/access_tokens | \
                    ${pkgs.jq}/bin/jq -r '.token' >/tmp/token-read-api
                """
            )
            token_read_api = gitlab.succeed("grep \"^glpat-\" /tmp/token-read-api").strip()

        with subtest("Prepare nix-daemon environment config"):
            client.succeed("touch /root/tokens.txt")
            client.succeed("chmod 400 /root/tokens.txt")
            client.succeed(
              f"""
              echo "
              NIX_GITLAB_PRIVATE_USERNAME=whatever
              NIX_GITLAB_PRIVATE_PASSWORD={token_read_repo}
              NIX_MYPREFIX_GITLAB_PRIVATE_USERNAME=whatever_myprefix
              NIX_MYPREFIX_GITLAB_PRIVATE_PASSWORD={token_read_api}
              " > /root/tokens.txt
              """
            )
            client.succeed("systemctl restart nix-daemon")

        with subtest("Fetch projects"):
            client.fail("${pkgs.sudo}/bin/sudo -u bob nix-build ${fetchAsPublic}")

            client.succeed("${pkgs.sudo}/bin/sudo -u bob nix-build ${fetchWithRepoScope}")

            client.succeed(""" [ "$(${pkgs.sudo}/bin/sudo -u bob find result/ -type f | wc -l)" = "1" ] """)

            # Alice adds another file, modifies the repo
            gitlab.succeed(
                """
                [ "$(curl \
                    -o /dev/null \
                    -w '%{http_code}' \
                    -X POST \
                    -H 'Content-Type: application/json' \
                    -H @/tmp/headers-alice \
                    -d @${putFile} \
                    http://gitlab/api/v4/projects/${aliceProjectId}/repository/files/other-file.txt)" = "201" ]"""
            )

            client.succeed("${pkgs.sudo}/bin/sudo -u bob nix-build ${fetchWithApiScope}")

            client.succeed(""" [ "$(${pkgs.sudo}/bin/sudo -u bob find result/ -type f | wc -l)" = "2" ] """)
      '';

    in
    ''
      start_all()
    ''
    + waitForServices
    + test;
}
