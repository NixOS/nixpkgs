{ lib, config, ... }:
let
  safeName = lib.types.strMatching "[a-zA-Z0-9:_\\.-]*";
  cfg = config.vars;

  delayedPackage =
    description:
    lib.mkOption {
      inherit description;
      type = lib.types.functionTo lib.types.package;
      example = pkgs: pkgs.writeShellScript "echo 'Hi!'";
    };

  nullableDelayedPackage =
    description:
    lib.mkOption {
      inherit description;
      type = lib.types.nullOr (lib.types.functionTo lib.types.package);
      example = pkgs: pkgs.writeShellScript "echo 'Hi!'";
      default = null;
    };

  backendModule = lib.types.submodule (
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          description = "The name of the backend.";
          type = lib.types.str;
          readOnly = true;
          default = name;
        };

        get = delayedPackage ''
          Given $1=gen_name and $2=file_name, the script retrieves the
          respective secret to $out.
        '';

        set = delayedPackage ''
          Given $1=gen_name and $2=file_name, the script retrieves the
          respective secret from $in and stores it in the appropriate location.
        '';

        exists = delayedPackage ''
          Given $1=gen_name and $2=file_name, the script exists with status
          code 0 if the secret exists, and with status code 1 otherwise.
        '';

        delete = nullableDelayedPackage ''
          Given $1=gen_name and $2=file_name, the script deletes the respective
          secret if it does exist.
        '';

        list = nullableDelayedPackage ''
          A script that lists all files managed by this backend. Should output
          space-separated or newline-separated pairs of: generator_name
          file_name.
        '';

        deploy = delayedPackage ''
          Given $1=gen_name and $2=file_name, the script deploys the respective
          secret to the target machine. Any additional information required by
          the deploy script can be provided by the user through environment
          variables.
        '';

        deployLocal = nullableDelayedPackage ''
          Given $1=gen_name and $2=file_name, the script deploys the respective
          secret to the machine with system root mounted at $3=system_root.
          This is useful for fresh installs from environments live live CDs,
          where the target system is not yet up and running (even if
          nixos-install has successfully completed).
        '';

        fixup = nullableDelayedPackage ''
          This script will be run on every invocation of the CLI's generator
          command. Given $1=gen_name and $2=file_name, the script performs any
          necessary updates to the secrets' files (e.g. rekeying encrypted
          secrets).
        '';
      };
    }
  );

  fileModule = lib.types.submodule (
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          description = "name of the generated file ";
          type = safeName;
          readOnly = true;
          default = name;
          defaultText = "Name of the file";
        };

        deploy = lib.mkOption {
          description = ''
            Whether the file should be deployed to the target machine. Disable
            this if the generated file is only used as an input to other
            generators.
          '';
          type = lib.types.bool;
          default = true;
        };

        secret = lib.mkOption {
          description = ''
            Whether the file should be treated as a secret. Backends might
            treat such files differently (e.g. they might choose not to encrypt
            them).
          '';
          type = lib.types.bool;
          default = true;
        };
      };
    }
  );

  generatorModule = lib.types.submodule (
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          description = ''
            The name of the generator.
            This name will be used to refer to the generator in other generators.
          '';
          type = safeName;
          readOnly = true;
          default = name;
          defaultText = "Name of the generator";
        };

        prompts = lib.mkOption {
          description = ''
            A list of prompts this generator will have at its disposal.
          '';
          type = lib.types.listOf safeName;
          default = [ ];
        };

        dependencies = lib.mkOption {
          description = ''
            A list of other generators this generator should be able to read the
            output(s) of.
          '';
          type = lib.types.listOf safeName;
          default = [ ];
        };

        files = lib.mkOption {
          description = ''
            A set of files to generate. The generator 'script' is expected to
            produce exactly these files under $out.
          '';
          type = lib.types.attrsOf fileModule;
          default = { };
        };

        script = delayedPackage ''
          The script to run to generate the files. The script will be run with
          the following environment variables:
            - $in: The directory containing the output values of all declared
              dependencies
            - $out: The output directory to put the generated files
            - $prompts: The directory containing the prompted values as files
          The script should produce the files specified in the 'files' attribute
          under $out.
        '';

        backend = lib.mkOption {
          type = safeName;
          description = "The backend responsible for handling this secret.";
          default = cfg.defaultGeneratorBackend;
        };
      };
    }
  );

  promptBackendModule = lib.types.submodule (
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          description = "The name of the backend.";
          type = lib.types.str;
          readOnly = true;
          default = name;
        };

        run = delayedPackage ''
          Given $1=prompt_type and $2=prompt_text, the script runs the prompt
          by the user, then saves respective value to $out.
        '';
      };
    }
  );

  promptModule = lib.types.submodule (
    { name, ... }:
    {
      name = lib.mkOption {
        description = "The name of the backend.";
        type = lib.types.str;
        readOnly = true;
        default = name;
      };

      description = lib.mkOption {
        description = ''
          The description of the prompted value
        '';
        type = lib.types.str;
        default = name;
        defaultText = "Name of the prompt";
        example = "SSH private key";
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

      backend = lib.mkOption {
        type = safeName;
        description = "The backend responsible for handling this prompt.";
        default = cfg.defaultPromptBackend;
      };
    }
  );
in
{
  options.vars = {
    generatorBackends = lib.mkOption {
      description = ''
        A set of backends that handle storing and retrieving generated files.
      '';
      default = { };
      type = lib.types.attrsOf backendModule;
    };

    generators = lib.mkOption {
      description = ''
        A set of generators that can be used to generate files. Generators are
        scripts that produce files based on the values of other generators and
        user input. Each generator is expected to produce a set of files under
        a directory.
      '';
      default = { };
      type = lib.types.attrsOf generatorModule;
    };

    defaultGeneratorBackend = lib.mkOption {
      description = ''
        The default backend to use for generators that do not specify one.
      '';
      type = safeName;
    };

    promptBackends = lib.mkOption {
      description = ''
        A set of backends that handle retrieving user inputs.
      '';
      default = { };
      type = lib.types.attrsOf promptBackendModule;
    };

    prompts = lib.mkOption {
      description = ''
        TODO
      '';
      default = { };
      type = lib.types.attrsOf promptModule;
    };

    defaultPromptBackend = lib.mkOption {
      description = ''
        The default backend to use for prompts that do not specify one.
      '';
      type = safeName;
    };
  };
}
