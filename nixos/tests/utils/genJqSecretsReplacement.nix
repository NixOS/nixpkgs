{ lib, pkgs, ... }:

let
  secretA = pkgs.writeText "secretA" "AAAAA";
  secretJSON = pkgs.writeText "secretA" (
    builtins.toJSON [
      { "a" = "topsecretpassword1234"; }
      { "b" = "topsecretpassword5678"; }
    ]
  );

  tests = {
    simple = {
      set = {
        example = [
          {
            irrelevant = "not interesting";
          }
          {
            ignored = "ignored attr";
            relevant = {
              secret = {
                _secret = secretA;
              };
            };
          }
        ];
      };
      expect = {
        example = [
          {
            irrelevant = "not interesting";
          }
          {
            ignored = "ignored attr";
            relevant = {
              secret = "AAAAA";
            };
          }
        ];
      };
    };

    structured = {
      set = {
        example = [
          {
            irrelevant = "not interesting";
          }
          {
            ignored = "ignored attr";
            relevant = {
              secret = {
                _secret = secretJSON;
                quote = false;
              };
            };
          }
        ];
      };
      expect = {
        example = [
          {
            irrelevant = "not interesting";
          }
          {
            ignored = "ignored attr";
            relevant = {
              secret = [
                { "a" = "topsecretpassword1234"; }
                { "b" = "topsecretpassword5678"; }
              ];
            };
          }
        ];
      };
    };

    loadCredentials = {
      set = {
        example = [
          {
            irrelevant = "not interesting";
          }
          {
            ignored = "ignored attr";
            relevant = {
              secret = {
                _secret = secretJSON;
                quote = false;
              };
            };
          }
        ];
      };
      opts = {
        loadCredential = true;
      };
      expect = {
        example = [
          {
            irrelevant = "not interesting";
          }
          {
            ignored = "ignored attr";
            relevant = {
              secret = [
                { "a" = "topsecretpassword1234"; }
                { "b" = "topsecretpassword5678"; }
              ];
            };
          }
        ];
      };
    };
  };
in
{
  name = "utils-genJqSecretsReplacement";
  meta.maintainers = [ pkgs.lib.maintainers.ibizaman ];

  nodes.machine =
    { lib, utils, ... }:
    let
      secretsReplacements = lib.mapAttrs (
        name: test:
        (utils.genJqSecretsReplacement (test.opts or { }) test.set "/var/lib/genJqTest-${name}/file")
      ) tests;
    in
    {
      systemd.services = lib.mapAttrs' (
        name: secretsReplacement:
        lib.nameValuePair "genJqTest-${name}" {
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            LoadCredential = secretsReplacement.credentials;
          };
          script = "echo 'Done generating files'";
          preStart = ''
            mkdir -p /var/lib/genJqTest-${name}
          ''
          + secretsReplacement.script;
        }
      ) secretsReplacements;
    };

  testScript = ''
    import json
    machine.start()
  ''
  + lib.concatStringsSep "\n" (
    lib.mapAttrsToList (
      name: test:
      let
        expect = pkgs.writeText "expect" (builtins.toJSON test.expect);
      in
      ''
        with subtest("${name}"):
            machine.wait_for_unit("genJqTest-${name}.service")
            gotRaw = machine.succeed("cat /var/lib/genJqTest-${name}/file")
            try:
                got = json.loads(gotRaw)
            except Exception:
                print(f"raw file: {gotRaw}")
                raise
            print(got)
            with open("${expect}", "r") as file:
                expect = json.loads(file.read())
            if got != expect:
                raise Exception(f"Unexpected file:\ngot={got}\n!=\nexpect={expect}")
      ''
    ) tests
  );

}
