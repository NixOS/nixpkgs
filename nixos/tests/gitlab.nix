# This test runs gitlab and checks if it works

let
  initialRootPassword = "notproduction";
in
import ./make-test.nix ({ pkgs, lib, ...} : with lib; {
  name = "gitlab";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ globin ];
  };

  nodes = {
    gitlab = { ... }: {
      virtualisation.memorySize = if pkgs.stdenv.is64bit then 4096 else 2047;
      systemd.services.gitlab.serviceConfig.Restart = mkForce "no";
      systemd.services.gitlab-workhorse.serviceConfig.Restart = mkForce "no";
      systemd.services.gitaly.serviceConfig.Restart = mkForce "no";
      systemd.services.gitlab-sidekiq.serviceConfig.Restart = mkForce "no";

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts = {
          "localhost" = {
            locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
          };
        };
      };

      services.gitlab = {
        enable = true;
        databasePassword = "dbPassword";
        inherit initialRootPassword;
        smtp.enable = true;
        secrets = {
          secret = "secret";
          otp = "otpsecret";
          db = "dbsecret";

          # nix-shell -p openssl --run "openssl genrsa 2048"
          jws = ''
            -----BEGIN RSA PRIVATE KEY-----
            MIIEpAIBAAKCAQEA13/qEio76OWUtWO0WIz9lWnsTWOU8Esv4sQHDq9PCEFsLt21
            PAXrlWhLjjWcxGfsrDwnh7YErGHYL62BMSxMdFJolaknlQK/O/V8UETDe45VoHM+
            Znk270RfUcfYFgiihnXUZXVmL0om9TsQSk646wCcjCY9LxtxUyKNhvT7KjgYw2aX
            z34aw7M+Js3T2p1TjZPSC82GtmtKkJEKFMi5EjprLTDE7EdcUzr9Xuw+kQ+gRm9k
            7FE+JQqSoprwE3Q0v2OAn3UhLMgg0gNFRnsc5l6IAshDzV+H22RPqKKlJjVjjfPY
            0TQSvYLVApigHbDPH0BoCXfjFfQazbbP3OUHrwIDAQABAoIBAQCMU+tkcMQaYIV5
            qLdjgkwO467QpivyXcOM8wF1eosIYTHFQvIlZ+WEoSmyLQ8shlADyBgls01Pw1c3
            lNAv6RzQEmmwKzpvOh61OKH+0whIiOMRXHoh2IUBQZCgfHYlwvGyhUAN4WjtGmhM
            AG4XNTQNM5S9Xpkw97nP3Qwz+YskbbkrfqtCEVy9ro+4nhbjqPsuO3adbnkva4zR
            cyurRhrHgHU6LPjn5NHnHH4qw2faY2oAsL8pmpkTbO5IqWDvOcbjNfjVPgVoq26O
            bbaa1qs4nmc80qQgMjRPJef535xyf3eLsSlDvpf6O8sPrJzVR1zaqEqixpQCZDac
            +kRiSBrhAoGBAOwHiq0PuyJh6VzBu7ybqX6+gF/wA4Jkwzx6mbfaBgurvU1aospp
            kisIonAkxSbxllZMnjbkShZEdATYKeT9o5NEhnU4YnHfc5bJZbiWOZAzYGLcY7g8
            vDQ31pBItyY4pFgPbSpNlbUvUsoPVJ45RasRADDTNCzMzdjFQQXst2V9AoGBAOm7
            sSpzYfFPLEAhieAkuhtbsX58Boo46djiKVfzGftfp6F9aHTOfzGORU5jrZ16mSbS
            qkkC6BEFrATX2051dzzXC89fWoJYALrsffE5I3KlKXsCAWSnCP1MMxOfH+Ls61Mr
            7pK/LKfvJt53mUH4jIdbmmFUDwbg18oBEH+x9PmbAoGAS/+JqXu9N67rIxDGUE6W
            3tacI0f2+U9Uhe67/DTZaXyc8YFTlXU0uWKIWy+bw5RaYeM9tlL/f/f+m2i25KK+
            vrZ7zNag7CWU5GJovGyykDnauTpZaYM03mN0VPT08/uc/zXIYqyknbhlIeaZynCK
            fDB3LUF0NVCknz20WCIGU0kCgYEAkxY0ZXx61Dp4pFr2wwEZxQGs7uXpz64FKyEX
            12r6nMATY4Lh6y/Px0W6w5vis8lk+5Ny6cNUevHQ0LNuJS+yu6ywl+1vrbrnqroM
            f3LvpcPeGLSoX8jl1VDQi7aFgG6LoKly1xJLbdsH4NPutB9PgBbbTghx9GgmI88L
            rPA2M6UCgYBOmkYJocNgxg6B1/n4Tb9fN1Q/XuJrFDE6NxVUoke+IIyMPRH7FC3m
            VMYzu+b7zTVJjaBb1cmJemxl/xajziWDofJYPefhdbOVU7HXtmJFY0IG3pVxU1zW
            3bmDj5QAtCUDpuuNa6GEIT0YR4+D/V7o3DmlZ0tVIwKJmVJoQ2f5dw==
            -----END RSA PRIVATE KEY-----
          '';
        };
      };
    };
  };

  testScript =
  let
    auth = pkgs.writeText "auth.json" (builtins.toJSON {
      grant_type = "password";
      username = "root";
      password = initialRootPassword;
    });

    createProject = pkgs.writeText "create-project.json" (builtins.toJSON {
      name = "test";
    });

    putFile = pkgs.writeText "put-file.json" (builtins.toJSON {
      branch = "master";
      author_email = "author@example.com";
      author_name = "Firstname Lastname";
      content = "some content";
      commit_message = "create a new file";
    });
  in
  ''
    $gitlab->start();
    $gitlab->waitForUnit("gitaly.service");
    $gitlab->waitForUnit("gitlab-workhorse.service");
    $gitlab->waitForUnit("gitlab.service");
    $gitlab->waitForUnit("gitlab-sidekiq.service");
    $gitlab->waitForFile("/var/gitlab/state/tmp/sockets/gitlab.socket");
    $gitlab->waitUntilSucceeds("curl -sSf http://gitlab/users/sign_in");
    $gitlab->succeed("curl -isSf http://gitlab  | grep -i location | grep -q http://gitlab/users/sign_in");
    $gitlab->succeed("${pkgs.sudo}/bin/sudo -u gitlab -H gitlab-rake gitlab:check 1>&2");
    $gitlab->succeed("echo \"Authorization: Bearer \$(curl -X POST -H 'Content-Type: application/json' -d @${auth} http://gitlab/oauth/token | ${pkgs.jq}/bin/jq -r '.access_token')\" >/tmp/headers");
    $gitlab->succeed("curl -X POST -H 'Content-Type: application/json' -H @/tmp/headers -d @${createProject} http://gitlab/api/v4/projects");
    $gitlab->succeed("curl -X POST -H 'Content-Type: application/json' -H @/tmp/headers -d @${putFile} http://gitlab/api/v4/projects/1/repository/files/some-file.txt");
    $gitlab->succeed("curl -H @/tmp/headers http://gitlab/api/v4/projects/1/repository/archive.tar.gz > /tmp/archive.tar.gz");
    $gitlab->succeed("curl -H @/tmp/headers http://gitlab/api/v4/projects/1/repository/archive.tar.bz2 > /tmp/archive.tar.bz2");
    $gitlab->succeed("test -s /tmp/archive.tar.gz");
    $gitlab->succeed("test -s /tmp/archive.tar.bz2");
  '';
})
