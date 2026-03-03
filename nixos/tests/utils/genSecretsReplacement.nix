{ lib, pkgs, ... }:

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

  generatorEqual = lib.generators.toKeyValue {
    mkKeyValue = lib.flip lib.generators.mkKeyValueDefault "=" {
      mkValueString =
        v:
        if builtins.isString v then
          ''"${v}"''
        else if builtins.isBool v then
          if v then "true" else "false"
        else
          throw "unsupported type ${builtins.typeOf v}: ${lib.mkValueString v}";
    };
  };

  tests = {
    simple = {
      escape_style = "json";
      generator = generatorEqual;
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
      escape_style = "json";
      generator = generatorEqual;
      set = {
        A = {
          _secret = secretA;
        };
        B = {
          _secret = secretB;
        };
      };
      expect = {
        A = "AAAAA";
        B = ''AAA"BB'CC"\n $1 $a $$ \"\\" \\ ''${value} DD'EE'';
      };
    };

    # It's a weird test since no one would ever want to do this
    # but this tests shows that quoting is indeed avoided for
    # structured secrets.
    structured = {
      escape_style = "json";
      generator = generatorEqual;
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
      escape_style = "json";
      generator = generatorEqual;
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
in
{
  name = "utils-genSecretsReplacement";
  meta.maintainers = [ pkgs.lib.maintainers.ibizaman ];

  nodes.machine =
    { lib, utils, ... }:
    let
      secretsReplacements = lib.mapAttrs (
        name: test:
        (utils.genSecretsReplacement { inherit (test) escape_style generator; } (test.opts or { }
        ) test.set "/var/lib/genJqTest-${name}/file")
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
            gotRaw = machine.succeed("cat /var/lib/genJqTest-${name}/file")
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
    ) tests
  );

}
