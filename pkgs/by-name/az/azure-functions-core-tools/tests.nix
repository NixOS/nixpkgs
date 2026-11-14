{
  lib,
  testers,
  runCommand,
  azure-functions-core-tools,
  go,
  python3,
}:

{
  version = testers.testVersion {
    package = azure-functions-core-tools;
    command = "func --version";
  };

  # Builds an attrset of tests for the `func init` command,
  # for each runtime, with a set of expected files to be created.
  # We also test a cartesian product of runtime-specific arguments, such as language.
  func-init =
    let
      mkInitTest =
        name:
        { args, expectedFiles }:
        runCommand "azure-functions-core-tools-test-init-${name}"
          {
            nativeBuildInputs = [
              azure-functions-core-tools
              go
              python3
            ];
          }
          ''
            set -e
            export HOME="$(mktemp -d)"

            func init --offline --no-bundle ${args}

            for file in ${
              lib.concatStringsSep " " (
                expectedFiles
                ++ [
                  ".gitignore"
                  "host.json"
                  "local.settings.json"
                ]
              )
            }; do
              echo "Checking for $file"
              test -f "$file"
            done

            touch "$out"
          '';

      runtimes = [
        {
          name = "dotnet-isolated";
          args = {
            language = [
              "csharp"
              "fsharp"
            ];
            target-framework = [
              "net8.0"
              "net9.0"
              "net10.0"
            ];
          };
          expectedFiles = [ ];
        }
        {
          name = "dotnet";
          args = {
            language = [
              "csharp"
            ];
            target-framework = [
              "net8.0"
            ];
          };
          expectedFiles = [ ];
        }
        {
          name = "node";
          args = {
            language = [
              "javascript"
              "typescript"
            ];
            model = [
              "v3"
              "v4"
            ];
          };
          expectedFiles = [
            "package.json"
          ];
        }
        {
          name = "python";
          args = {
            model = [
              "v1"
              "v2"
            ];
          };
          expectedFiles = [
            "requirements.txt"
          ];
        }
        {
          name = "go";
          args = { };
          expectedFiles = [
            "go.mod"
            "main.go"
          ];
        }
        {
          name = "powershell";
          args = { };
          expectedFiles = [ "requirements.psd1" ];
        }
      ];
    in
    lib.pipe runtimes [
      (lib.map (
        runtime:
        lib.nameValuePair runtime.name (
          lib.pipe runtime.args [
            (lib.mapCartesianProduct (
              args:
              let
                variant =
                  if args == { } then
                    "default"
                  else
                    lib.pipe args [
                      lib.attrValues
                      (lib.concatStringsSep "-")
                      (lib.replaceStrings [ "." ] [ "-" ])
                    ];
              in
              lib.nameValuePair variant (
                mkInitTest "${runtime.name}-${variant}" {
                  args = "--worker-runtime ${runtime.name} ${
                    lib.concatMapAttrsStringSep " " (flag: value: "--${flag} ${args.${flag}}") args
                  }";
                  inherit (runtime) expectedFiles;
                }
              )
            ))
            lib.listToAttrs
            lib.recurseIntoAttrs
          ]
        )
      ))
      lib.listToAttrs
      lib.recurseIntoAttrs
    ];
}
