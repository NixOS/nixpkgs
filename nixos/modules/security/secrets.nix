{ lib, config, ... }:
with lib.types;
let
  # A name containing only "safe" characters that we allow passing to the
  # backends.
  #
  # Note that we often default options of type `safeName` to Nix attribute
  # names. For example,
  # ```
  # secrets.generators."foo bar" = {}
  # ```
  # will implicitly set `secrets.generators."foo bar".name = "foo bar"`. This is
  # bad, because the error will get a confusing error coming from the wrong
  # place. In the future, it might be worth creating a modified version of
  # `attrsOf` that does not have this issue, although the added complexity is
  # not worth it right now.
  safeName =
    of:
    addCheck str (
      s:
      if lib.strings.match "[a-zA-Z0-9:_\\.-]*" s == null then
        throw "Name '${toString s}' is not a valid ${of} name. Currently, only alphanumeric characters, dashes, underscores, and dots are allowed."
      else
        true
    );
  cfg = config.secrets;

  deferredPackage =
    description:
    lib.mkOption {
      inherit description;
      type = functionTo pathInStore;
      example = pkgs: pkgs.writeShellScript "example" "echo 'Hi!'";
    };

  nullableDeferredPackage =
    description:
    lib.mkOption {
      inherit description;
      type = nullOr (functionTo pathInStore);
      example = pkgs: pkgs.writeShellScript "example" "echo 'Hi!'";
      default = null;
    };

  generatorBackendModule = submodule (
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          description = "The name of the backend.";
          type = str;
          default = name;
        };

        get = nullableDeferredPackage ''
          Given $1=gen_name and $2=file_name, the script retrieves the
          respective secret to $out.
        '';

        set = deferredPackage ''
          Given $1=gen_name and $2=file_name, the script retrieves the
          respective secret from $in and stores it in the appropriate location.
        '';

        exists = deferredPackage ''
          Given $1=gen_name and $2=file_name, the script exists with status
          code 0 if the secret exists, and with status code 42 otherwise.

          This script must not perform side effects.
        '';

        delete = nullableDeferredPackage ''
          Given $1=gen_name and $2=file_name, the script deletes the respective
          secret if it does exist.
        '';

        list = nullableDeferredPackage ''
          A script that lists all files managed by this backend. Should output
          space-separated or newline-separated pairs of: generator_name
          file_name.

          If the backend supports multiple hosts, then this command should only
          list the secrets owned by the current host. In particular, files
          included in this command's output will be deleted by the
          collect-garbage command, unless they appear in the user's generator
          configuration.

          This script must not perform side effects.
        '';

        fixup = nullableDeferredPackage ''
          This script will be run on every invocation of the CLI's generator
          command. Given $1=file_list in the same format used by `list`, the
          script performs any necessary updates to the secrets' files (e.g.
          rekeying encrypted secrets). This script can perform side effects,
          but must be idempotent.
        '';

        deploy.remote = nullableDeferredPackage ''
          Deploys every available file to the given machine. The list of files
          to deploy is provided as $1 in the same format used by `list`. Any
          additional information required by the deploy script can be provided
          by the user through environment variables.
        '';

        deploy.local = nullableDeferredPackage ''
          Deploys every available file to the machine with system root mounted
          at $1=system_root. The list of files to deploy is provided as $2 in
          the same format used by `list`. This is useful for fresh installs
          from environments live live CDs, where the target system is not yet
          up and running (even if nixos-install has successfully completed).
        '';

        fileModule = lib.mkOption {
          type = deferredModule;
          internal = true;
          default = { };
          description = ''
            A module to be imported in every
            secrets.generators.<name>.files.<name> submodule. Used by backends to
            define the `path` attribute. The module will have the following
            additional arguments passed to it:
            - `generator`, containing the generator the file belongs to
            - `backend`, containing the backend associated with said generator
          '';
        };
      };
    }
  );

  fileModule =
    { name, backend, ... }:
    {
      imports = [ backend.fileModule ];
      options = {
        name = lib.mkOption {
          description = "name of the generated file";
          type = safeName "file";
          default = name;
          defaultText = "Name of the file";
        };

        path = lib.mkOption {
          description = "Path to the generated file; usually set by the backend";
          type = path;
        };

        local = lib.mkOption {
          description = ''
            Files with this flag will not be included in the file list passed to
            the `deploy` script.
          '';
          type = bool;
          default = false;
        };
      };
    };

  generatorModule = submodule (
    { name, config, ... }:
    let
      backend = cfg.generatorBackends.${config.backend};
    in
    {
      options = {
        name = lib.mkOption {
          description = ''
            The name of the generator.
            This name will be used to refer to the generator in other generators.
          '';
          type = safeName "generator";
          default = name;
          defaultText = "Name of the generator";
        };

        prompts = lib.mkOption {
          description = ''
            A list of prompts this generator will have at its disposal.
          '';
          type = listOf str;
          default = [ ];
        };

        dependencies = lib.mkOption {
          description = ''
            A list of other generators this generator should be able to read the
            output(s) of.
          '';
          type = listOf (safeName "generator");
          default = [ ];
        };

        files = lib.mkOption {
          description = ''
            A set of files to generate. The generator 'script' is expected to
            produce exactly these files under $out.
          '';
          default = { };
          type = attrsOf (submoduleWith {
            modules = [ fileModule ];
            specialArgs = {
              inherit backend;
              generator = config;
            };
          });
        };

        script = deferredPackage ''
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
          type = str;
          description = "The backend responsible for handling this secret.";
          default = cfg.defaultGeneratorBackend;
        };
      };
    }
  );

  promptBackendModule = submodule (
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          description = "The name of the backend.";
          type = str;
          default = name;
        };

        script = deferredPackage ''
          Given $1=prompt_type, $2=prompt_label, and optionally
          $3=prompt_description, the script runs the prompt by the user, then
          saves respective value to $out.
        '';
      };
    }
  );

  promptModule = submodule (
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          description = "The name generators can use to refer to this prompt.";
          type = str;
          default = name;
        };

        label = lib.mkOption {
          description = "The label to attach to the prompt.";
          type = str;
          default = name;
        };

        description = lib.mkOption {
          description = ''
            An optional longer description of the prompted value.
          '';
          type = nullOr str;
          default = null;
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
          type = enum [
            "hidden"
            "line"
            "multiline"
          ];
          default = "line";
        };

        backend = lib.mkOption {
          type = str;
          description = "The backend responsible for handling this prompt.";
          default = cfg.defaultPromptBackend;
        };
      };
    }
  );
in
{
  options.secrets = {
    generatorBackends = lib.mkOption {
      description = ''
        A set of backends that handle storing and retrieving generated files.
      '';
      default = { };
      type = attrsOf generatorBackendModule;
    };

    generators = lib.mkOption {
      description = ''
        A set of generators that are each expected to produce a set of files
        under a directory. Generators can produce files using a script,
        possibly referencing values produced by other generators and user
        input.
      '';
      default = { };
      type = attrsOf generatorModule;
    };

    defaultGeneratorBackend = lib.mkOption {
      description = ''
        The default backend to use for generators that do not specify one.
      '';
      type = str;
    };

    promptBackends = lib.mkOption {
      description = ''
        A set of backends that handle retrieving user inputs.
      '';
      default = { };
      type = attrsOf promptBackendModule;
    };

    prompts = lib.mkOption {
      description = ''
        A set of prompts the user can use to provide manual input to the
        generator backends.
      '';
      default = { };
      type = attrsOf promptModule;
    };

    defaultPromptBackend = lib.mkOption {
      description = ''
        The default backend to use for prompts that do not specify one.
      '';
      type = str;
    };
  };
}
