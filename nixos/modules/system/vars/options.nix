{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.vars = {
    settings = {
      fileModule = lib.mkOption {
        type = lib.types.deferredModule;
        internal = true;
        description = ''
          A module to be imported in every vars.files.<name> submodule.
          Used by backends to define the `path` attribute.

          Takes the file as an argument and returns maybe an attrset which should at least contain the `path` attribute.
          Can be used to set other file attributes as well, like `value`.
        '';
        default = { };
      };
    };
    generators = lib.mkOption {
      description = ''
        A set of generators that can be used to generate files.
        Generators are scripts that produce files based on the values of other generators and user input.
        Each generator is expected to produce a set of files under a directory.
      '';
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule (generator: {
          options = {
            name = lib.mkOption {
              type = lib.types.strMatching "[a-zA-Z0-9:_\\.-]*";
              description = ''
                The name of the generator.
                This name will be used to refer to the generator in other generators.
              '';
              readOnly = true;
              default = generator.config._module.args.name;
              defaultText = "Name of the generator";
            };

            dependencies = lib.mkOption {
              description = ''
                A list of other generators that this generator depends on.
                The output values of these generators will be available to the generator script as files.
                For example, the file 'file1' of a dependency named 'dep1' will be available via $in/dep1/file1.
              '';
              type = lib.types.listOf lib.types.str;
              default = [ ];
            };
            files = lib.mkOption {
              description = ''
                A set of files to generate.
                The generator 'script' is expected to produce exactly these files under $out.
              '';
              defaultText = "attrs of files";
              type = lib.types.attrsOf (
                lib.types.submodule (file: {
                  imports = [
                    config.vars.settings.fileModule
                  ];
                  options = {
                    name = lib.mkOption {
                      type = lib.types.strMatching "[a-zA-Z0-9:_\\.-]*";
                      description = ''
                        name of the generated file
                      '';
                      readOnly = true;
                      default = file.config._module.args.name;
                      defaultText = "Name of the file";
                    };
                    generator = lib.mkOption {
                      description = ''
                        The generator that produces the file.
                        This is the name of another generator.
                      '';
                      type = lib.types.strMatching "[a-zA-Z0-9:_\\.-]*";
                      readOnly = true;
                      internal = true;
                      default = generator.config.name;
                      defaultText = "Name of the generator";
                    };
                    deploy = lib.mkOption {
                      description = ''
                        Whether the file should be deployed to the target machine.

                        Disable this if the generated file is only used as an input to other generators.
                      '';
                      type = lib.types.bool;
                      default = true;
                    };
                    secret = lib.mkOption {
                      description = ''
                        Whether the file should be treated as a secret.
                      '';
                      type = lib.types.bool;
                      default = true;
                    };
                    path = lib.mkOption {
                      description = ''
                        The path to the file containing the content of the generated value.
                        This will be set automatically
                      '';
                      type = lib.types.nullOr lib.types.str;
                      default = null;
                    };
                  };
                })
              );
            };
            prompts = lib.mkOption {
              description = ''
                A set of prompts to ask the user for values.
                Prompts are available to the generator script as files.
                For example, a prompt named 'prompt1' will be available via $prompts/prompt1
              '';
              default = { };
              type = lib.types.attrsOf (
                lib.types.submodule (prompt: {
                  options = {
                    name = lib.mkOption {
                      description = ''
                        The name of the prompt.
                        This name will be used to refer to the prompt in the generator script.
                      '';
                      type = lib.types.strMatching "[a-zA-Z0-9:_\\.-]*";
                      default = prompt.config._module.args.name;
                      defaultText = "Name of the prompt";
                    };
                    description = lib.mkOption {
                      description = ''
                        The description of the prompted value
                      '';
                      type = lib.types.str;
                      example = "SSH private key";
                      default = prompt.config._module.args.name;
                      defaultText = "Name of the prompt";
                    };
                    type = lib.mkOption {
                      description = ''
                        The input type of the prompt.
                        The following types are available:
                          - hidden: A hidden text (e.g. password)
                          - line: A single line of text
                          - multiline: A multiline text
                      '';
                      type = lib.types.enum [
                        "hidden"
                        "line"
                        "multiline"
                      ];
                      default = "line";
                    };
                  };
                })
              );
            };
            runtimeInputs = lib.mkOption {
              description = ''
                A list of packages that the generator script requires.
                These packages will be available in the PATH when the script is run.
              '';
              type = lib.types.listOf lib.types.package;
              default = [ pkgs.coreutils ];
            };
            script = lib.mkOption {
              description = ''
                The script to run to generate the files.
                The script will be run with the following environment variables:
                  - $in: The directory containing the output values of all declared dependencies
                  - $out: The output directory to put the generated files
                  - $prompts: The directory containing the prompted values as files
                The script should produce the files specified in the 'files' attribute under $out.
              '';
              type = lib.types.either lib.types.str lib.types.path;
              default = "";
            };
          };
        })
      );
    };
  };
}
