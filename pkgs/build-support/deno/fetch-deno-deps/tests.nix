{ callPackage, lib }:
let
  inherit (callPackage ./lib.nix { }) fetcher;

  # we want files with `outPath` to be left alone
  # we want files with a hash to get a `derivation` and `outPath`
  # we want files with just a url to be part of the top level derivation
  fixtures = [
    {
      input = {
        hash = "sha256-HmvHlr26JkRYdSyzER7fV6kfxO+e/cgauV5aY4j75eI=";
        meta = {
          data = "global meta";
        };
        packages = {
          package1 = {
            files = {
              fileWithHash = {
                hash = "sha256-8ZADzAGTFtLA5s0wABFvW1Q5bYROyWrOiz4d3fIurVI=";
                meta = {
                  data = "fileWithHash meta";
                };
                url = "https://jsr.io/@std/cli/1.0.17/prompt_secret.ts";
              };
              fileWithOutPath = {
                derivation = {
                  type = "derivation";
                };
                meta = {
                  data = "fileWithOutPath meta";
                };
                outPath = "a";
                url = "a";
              };
            };
            meta = {
              data = "package1 meta";
            };
          };
          package2 = {
            files = {
              fileWithoutHash = {
                meta = {
                  data = "fileWithoutHash meta";
                };
                url = "https://jsr.io/@std/cli/1.0.17/prompt_secret.ts";
              };
              fileWithHash = {
                hash = "sha256-8ZADzAGTFtLA5s0wABFvW1Q5bYROyWrOiz4d3fIurVI=";
                meta = {
                  data = "fileWithHash meta";
                };
                url = "https://jsr.io/@std/cli/1.0.17/prompt_secret.ts";
              };
              fileWithOutPath = {
                derivation = {
                  type = "derivation";
                };
                meta = {
                  data = "fileWithOutPath meta";
                };
                outPath = "a";
                url = "a";
              };
            };
            meta = {
              data = "package2 meta";
            };
          };
        };
      };
      expectedOutput = {
        derivation = {
          type = "derivation";
        };
        hash = "sha256-HmvHlr26JkRYdSyzER7fV6kfxO+e/cgauV5aY4j75eI=";
        meta = {
          data = "global meta";
        };
        packages = {
          package1 = {
            files = {
              fileWithHash = {
                derivation = {
                  type = "derivation";
                };
                hash = "sha256-8ZADzAGTFtLA5s0wABFvW1Q5bYROyWrOiz4d3fIurVI=";
                meta = {
                  data = "fileWithHash meta";
                };
                outPath = "/nix/store/iwbiyw96ni9596blfry7d7d791y2fanw-prompt_secret.ts";
                url = "https://jsr.io/@std/cli/1.0.17/prompt_secret.ts";
              };
              fileWithOutPath = {
                derivation = {
                  type = "derivation";
                };
                meta = {
                  data = "fileWithOutPath meta";
                };
                outPath = "a";
                url = "a";
              };
            };
            meta = {
              data = "package1 meta";
            };
          };
          package2 = {
            files = {
              fileWithHash = {
                derivation = {
                  type = "derivation";
                };
                hash = "sha256-8ZADzAGTFtLA5s0wABFvW1Q5bYROyWrOiz4d3fIurVI=";
                meta = {
                  data = "fileWithHash meta";
                };
                outPath = "/nix/store/iwbiyw96ni9596blfry7d7d791y2fanw-prompt_secret.ts";
                url = "https://jsr.io/@std/cli/1.0.17/prompt_secret.ts";
              };
              fileWithOutPath = {
                derivation = {
                  type = "derivation";
                };
                meta = {
                  data = "fileWithOutPath meta";
                };
                outPath = "a";
                url = "a";
              };
              fileWithoutHash = {
                meta = {
                  data = "fileWithoutHash meta";
                };
                outPath = "/nix/store/qlsyqhfq6iwyrbrbjdg8p3vha3sdkwv5-fetcher-0/b4bb64dcb9da2859072f4e2c48ef4682c57f75620753bc538a1a567dab31fa3e";
                url = "https://jsr.io/@std/cli/1.0.17/prompt_secret.ts";
              };
            };
            meta = {
              data = "package2 meta";
            };
          };
        };
      };
    }
  ];

  test1 = builtins.map (
    f:
    let
      output = fetcher f.input;
      expectedOutput = f.expectedOutput;
      compareDeep = lib.mapAttrsRecursiveCond (as: !(as ? "type" && as.type == "derivation")) (
        path: value:
        let
          actualValue = value;
          expectedValue = lib.attrsets.attrByPath (builtins.trace path path) (
            assert false;
            null
          ) expectedOutput;
        in
        assert (builtins.trace actualValue actualValue) == (builtins.trace expectedValue expectedValue);
        value
      ) output;
    in
    builtins.deepSeq compareDeep "success"
  ) fixtures;
in
{
  inherit test1;
}
