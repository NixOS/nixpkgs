{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types)
    attrs
    lazyAttrsOf
    functionTo
    submodule
    listOf
    str
    deferredModule
    optionType
    ;
in
{
  options.contracts = mkOption {
    description = ''
      Base option for a contract.

      To create a new contract, add an instance of `config.contracts.<name>`
      and define the `meta`, `input` and `output` options.
      The `consumer` and `provider` options will then be set up automatically
      and contain respectively the type of a consumer and provider
      of this new contract.

      To use the `<name>` contract, declare an option with either the
      `config.contracts.<name>.consumer` or `config.contracts.<name>.provider`
      type.

      The `behaviorTest` option is used to ensure all `provider` of a contract
      behave the same way.
    '';
    type = lazyAttrsOf (
      submodule (interface: {
        options = {
          meta = mkOption {
            description = ''
              Useful information about the contract and its maintenance.
            '';
            type = submodule {
              options = {
                maintainers = mkOption {
                  description = ''
                    Maintainers of the contract.
                  '';
                  type = listOf str;
                };
                description = mkOption {
                  description = ''
                    Description of the contract.
                  '';
                  type = str;
                };
              };
            };
          };
          input = mkOption {
            description = ''
              Input type of a contract.
            '';
            type = deferredModule;
          };
          output = mkOption {
            description = ''
              Output type of a contract.
            '';
            type = deferredModule;
          };
          consumer = mkOption {
            description = ''
              Consumer type for a contract.

              This option is set up automatically.
              Define instead the `input` and `output` options.
            '';
            type = optionType;
            readOnly = true;
            defaultText = lib.literalExpression ''
              submodule (consumer: {
                options = {
                  provider = mkOption {
                    type = interface.config.provider;
                  };
                  input = mkOption {
                    type = submodule interface.config.input;
                  };
                  output = mkOption {
                    type = submodule interface.config.output;
                    readOnly = true;
                    default = consumer.config.provider.output;
                  };
                };
              })
            '';
            default = submodule (consumer: {
              options = {
                provider = mkOption {
                  type = interface.config.provider;
                };
                input = mkOption {
                  type = submodule interface.config.input;
                };
                output = mkOption {
                  type = submodule interface.config.output;
                  readOnly = true;
                  default = consumer.config.provider.output;
                };
              };
            });
          };
          provider = mkOption {
            description = ''
              Provider type for a contract.

              This option is set up automatically.
              Define instead the `input` and `output` options.
            '';
            type = optionType;
            readOnly = true;
            defaultText = lib.literalExpression ''
              submodule (provider: {
                options = {
                  consumer = mkOption {
                    type = lib.types.nullOr interface.config.consumer;
                    default = null;
                  };
                  input = mkOption {
                    type = lib.types.nullOr (submodule interface.config.input);
                    readOnly = true;
                    default = provider.config.consumer.input or null;
                  };
                  output = mkOption {
                    type = submodule interface.config.output;
                  };
                };
              }
            '';
            default = submodule (provider: {
              options = {
                consumer = mkOption {
                  type = interface.config.consumer;
                };
                input = mkOption {
                  type = submodule interface.config.input;
                  readOnly = true;
                  default = provider.config.consumer.input;
                };
                output = mkOption {
                  type = submodule interface.config.output;
                };
              };
            });
            behaviorTest = mkOption {
              # The type should be more precise of course.
              # There should actually be a NixOSTest type.
              # And we can probably do something fancy with the `input` and `output` deferred modules.
              type = functionTo attrs;
            };
          };
        };
      })
    );
  };
}
