{
  lib,
  pkgs,
  ...
}:

let
  secretA = pkgs.writeText "secretA" "AAAAA";
  secretB = pkgs.writeText "secretB" ''AAA"BB'CC"\n $1 $a $$ \"\\" \\ ''${value} DD'EE'';
  secretStructured = pkgs.writeText "secretStructured" ''
    "aaa"
    B="bbb"
  '';
  secretStructuredB = pkgs.writeText "secretStructured" ''
    "aaa \" \n $1 $a $$ ' ''${value}"
    B="bbb \" \n $1 $a $$ ' ''${value}"
  '';

  tests = {
    simple = {
      escape_style = "key_value";
      generator = (pkgs.formats.keyValue { }).generate;
      set = {
        A = {
          _secret = secretA;
        };
        B = true;
      };
      expect = {
        A = "AAAAA";
        B = true;
      };
    };

    simpleWithQuotes = {
      escape_style = "key_value";
      generator = (pkgs.formats.keyValue { }).generate;
      set = {
        A = {
          _secret = secretA;
        };
        "AAA\"BB'CC\" $1 . $a ? $$ \"\\\" \\ ''\${value} DD'EE" = {
          _secret = secretB;
        };
      };
      expect = {
        A = "AAAAA";
        # We cannot include newlines in the keys and values because these are not handled by the configuration format.
        "AAA\"BB'CC\" $1 . $a ? $$ \"\\\" \\ ''\${value} DD'EE" =
          ''AAA"BB'CC"\n $1 $a $$ \"\\" \\ ''${value} DD'EE'';
      };
    };

    # It's a weird test since no one would ever want to do this
    # but this tests shows that quoting is indeed avoided for
    # structured secrets.
    structured = {
      escape_style = "key_value";
      generator = (pkgs.formats.keyValue { }).generate;
      set = {
        A = {
          _secret = secretStructured;
          quote = false;
        };
      };
      expect = {
        A = "aaa";
        B = "bbb";
      };
    };

    structuredWithQuotes = {
      escape_style = "key_value";
      generator = (pkgs.formats.keyValue { }).generate;
      set = {
        "my \\ super \" '' secret" = {
          _secret = secretStructuredB;
          quote = false;
        };
      };
      expect = {
        "my \\ super \" '' secret" = "aaa \" \n $1 $a $$ ' \${value}";
        B = "bbb \" \n $1 $a $$ ' \${value}";
      };
    };
  };

  mkScript =
    utils: name: test:
    utils.genSecretsReplacement {
      inherit (test) escape_style generator;
    } { inherit (test) loadCredential; } test.set "/etc/genJqTest-${name}/config";

  allTests = lib.listToAttrs (
    lib.flatten (
      lib.mapAttrsToList (name: test: [
        (lib.nameValuePair name (
          test
          // {
            loadCredential = false;
          }
        ))
        (lib.nameValuePair "${name}_loadCredential" (
          test
          // {
            loadCredential = true;
          }
        ))
      ]) tests
    )
  );
in
{
  name = "utils-genSecretsReplacement";
  meta.maintainers = [ pkgs.lib.maintainers.ibizaman ];

  nodes.machine =
    { lib, utils, ... }:
    {
      users.users.other = {
        isSystemUser = true;
        group = "other";
      };
      users.groups.other = { };

      systemd.tmpfiles.settings = lib.mapAttrs (name: test: {
        "/etc/genJqTest-${name}" = {
          d = {
            user = if test.loadCredential then "other" else "root";
            # Makes sure this works with restrictive permissions.
            mode = "0700";
          };
        };
      }) allTests;

      systemd.services = lib.mapAttrs' (
        name: test:
        let
          secretsReplacement = mkScript utils name test;
        in
        lib.nameValuePair "genJqTest-${name}" {
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            LoadCredential = lib.mkIf test.loadCredential secretsReplacement.credentials;
            User = lib.mkIf test.loadCredential "other";
          };
          script = "echo 'Done generating files'";
          preStart = secretsReplacement.script;
        }
      ) allTests;
    };

  testScript = ''
    import json
    machine.start()

    def parse(raw):
        content = {}
        for line in raw.splitlines():
            split = line.split("=")
            if len(split) == 2:
                key = split[0]
                value = split[1]
                if len(value) >= 2 and value[0] == '"' and value[-1] == '"':
                    value = json.loads(value)
                elif value == "true":
                    value = True
                elif value == "false":
                    value = False
                content[key] = value
        return content
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
            gotRaw = machine.succeed("cat /etc/genJqTest-${name}/config")
            try:
                got = parse(gotRaw)
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
    ) allTests
  );

}
