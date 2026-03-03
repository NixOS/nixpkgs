{ lib, pkgs, ... }:

let
  secretA = pkgs.writeText "secretA" "AAAAA";
  secretB = pkgs.writeText "secretB" ''AAA"BB'CC"\n $1 $a $$ \"\\" \\ ''${value} DD'EE'';
  secretJSON = pkgs.writeText "secretJSON" (
    builtins.toJSON [
      { "a" = "topsecretpassword1234"; }
      { "b" = "topsecretpassword5678"; }
    ]
  );
  secretJSONB = pkgs.writeText "secretJSONB" (
    builtins.toJSON [
      { "my \\ super \" '' \n secret" = "topsecretpassword1234"; }
      { "b" = ''AAA"BB'CC"\n $1 $a $$ \"\\" \\ ''${value} DD'EE''; }
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

    simpleWithQuotes = {
      set = {
        example = [
          {
            "my \\ super \" '' \n secret" = {
              _secret = secretA;
            };
            secret2 = {
              _secret = secretB;
            };
          }
        ];
      };
      expect = {
        example = [
          {
            "my \\ super \" '' \n secret" = "AAAAA";
            secret2 = ''AAA"BB'CC"\n $1 $a $$ \"\\" \\ ''${value} DD'EE'';
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

    structuredWithQuotes = {
      set = {
        secret = {
          _secret = secretJSONB;
          quote = false;
        };
      };
      expect = {
        secret = [
          { "my \\ super \" '' \n secret" = "topsecretpassword1234"; }
          { "b" = ''AAA"BB'CC"\n $1 $a $$ \"\\" \\ ''${value} DD'EE''; }
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
            print(gotRaw)
            print(got)
            with open("${expect}", "r") as file:
                expect = json.loads(file.read())
            if got != expect:
                raise Exception(f"Unexpected file:\ngot={got}\n!=\nexpect={expect}")
      ''
    ) tests
  );

}
