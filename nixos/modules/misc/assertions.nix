{ lib, ... }:
let
  collect' =
    let
      collect'' =
        path: pred: value:
        if pred value then
          [ { inherit path value; } ]
        else if lib.isAttrs value then
          lib.concatMap ({ name, value }: collect'' (path ++ [ name ]) pred value) (lib.attrsToList value)
        else
          [ ];
    in
    collect'' [ ];
in
{
  options = {
    assertions = lib.mkOption {
      type =
        let
          assertionItemType = lib.types.submodule (
            { config, ... }:
            {
              options = {
                enable = lib.mkOption {
                  description = ''
                    Whether to enable this assertion.

                    This option is mostly useful for users, in order to forcefully disable assertions they believe to be
                    erroneous while waiting for someone to fix the assertion upstream.
                  '';
                  type = lib.types.bool;
                  default = true;
                  example = false;
                };

                assertion = lib.mkOption {
                  description = "Condition to be asserted. If this is `false`, the evaluation will throw the error";
                  type = lib.types.bool;
                  example = false;
                };

                message = lib.mkOption {
                  description = "The contents of the error message that should be shown upon triggering a false assertion";
                  type = if config.lazy then lib.types.unspecified else lib.types.nonEmptyStr;
                  example = "This is an example error message";
                };

                lazy = lib.mkOption {
                  description = ''
                    Whether to avoid evaluating the message contents until the assertion condition occurs.

                    This will also disable typechecking.

                    ::: {.note}
                    We do not recommend you enable this. It is mostly intended for backwards compatibility.
                    If you do need to enable it, make sure to double check that your `message` always will
                    evaluate successfully whenever the assertion would trigger.
                    :::
                  '';
                  type = lib.types.bool;
                  default = false;
                  example = true;
                };
              };
            }
          );

          flattenedAssertionItemType = lib.types.submodule {
            options = {
              assertion = lib.mkOption {
                type = lib.types.bool;
                description = "Condition to be asserted. If this is `false`, the evaluation will throw the error";
              };
              message = lib.mkOption {
                type = lib.types.nonEmptyStr;
                description = "The contents of the error message that should be shown upon triggering a false assertion";
              };
            };
          };

          # This may be replaced when `types.record` or similar is available,
          # see https://github.com/NixOS/nixpkgs/pull/334680
          checkedAssertionItemType =
            let
              check = x: x ? assertion && x ? message;
            in
            lib.types.addCheck assertionItemType check;

          nestedAssertionAttrsType =
            with lib.types;
            let
              isBranchNode = x: x == { } || lib.any lib.isAttrs (lib.attrValues x);

              nestedAssertionItemType =
                (oneOf [
                  checkedAssertionItemType
                  (addCheck (attrsOf nestedAssertionItemType) isBranchNode)
                ])
                // {
                  description = "nested attrs of (${assertionItemType.description})";
                };
            in
            nestedAssertionItemType;

          # Backwards compatibility for assertions that are still written as attrs inside a list.
          #
          # Unlike warnings where all messages are hidden behind `mkIf` statements, giving a relatively good guarantee
          # that a message will evaluate correctly when it appears, assertions are present even when the condition holds.
          # Some assertions might not expect their message to be evaluated unless the assertion fails, so we can't use
          # the hash of the message for naming. Instead, we use a number derived from the order in which the assertions
          # was discovered. This is not very stable, so it's not really recommended to use this name to set `enable = false`
          coercedAssertionAttrs =
            let
              coerce = xs: {
                legacy = lib.listToAttrs (
                  lib.imap0 (i: assertion: lib.nameValuePair "anon-${toString i}" (assertion // { lazy = true; })) xs
                );
              };
            in
            with lib.types;
            coercedTo (listOf (attrsOf unspecified)) coerce (
              submodule (
                { config, ... }: {
                  freeformType = nestedAssertionAttrsType;
                  options = {
                    __flattened = lib.mkOption {
                      type = listOf flattenedAssertionItemType;
                      internal = true;
                      description = ''
                        All failed assertions collected down to a flat list, provided in the
                        `{ assertion, message }` shape expected by `lib.asserts.checkAssertWarn`.
                      '';
                    };
                  };

                  config.__flattened = lib.mkForce (
                    let
                      assertionItems = collect' (x: lib.isAttrs x && x ? assertion && x ? enable && x ? message) (
                        removeAttrs config [
                          "__flattened"
                          "_module"
                        ]
                      );

                      failedAssertions = lib.filter (
                        x: x.value.enable == true && x.value.assertion == false
                      ) assertionItems;
                    in
                    map (x: {
                      inherit (x.value) assertion;
                      message = "assertions." + (lib.showAttrPath x.path) + ":\n" + x.value.message;
                    }) failedAssertions
                  );
                }
              )
            );
        in
        coercedAssertionAttrs;
      internal = true;
      default = { };
      example = lib.literalExpression ''
        {
          programs.foo.dontUseSomeOption = {
            assertion = !config.programs.foo.settings.someOption;
            message = "You can't enable foo's someOption for some reason";
          };
          services.bar.mutuallyExclusiveWithFoo = {
            assertion = config.services.bar.enable -> !config.programs.foo.enable;
            message = "You can't use the 'foo' program if you're using the 'bar' service";
          };
        }
      '';
      description = ''
        This option allows modules to express conditions that must
        hold for the evaluation of the system configuration to
        succeed, along with associated error messages for the user.
      '';
    };

    warnings = lib.mkOption {
      type =
        let
          warningItemType = lib.types.submodule {
            options = {
              enable = lib.mkOption {
                description = ''
                  Whether to enable this warning.

                  This option is mostly useful for users, in order to forcefully disable warnings they believe to be
                  erroneous while waiting for someone to fix the condition upstream.
                '';
                type = lib.types.bool;
                default = true;
                example = false;
              };

              condition = lib.mkOption {
                description = "Condition that triggers the warning message. If this is `true`, the warning will be shown";
                type = lib.types.bool;
                example = true;
              };

              message = lib.mkOption {
                description = "The contents of the warning message that should be shown upon triggering the condition";
                type = lib.types.nonEmptyStr;
                example = "This is an example warning message";
              };
            };
          };

          # This might be replaced when tagged submodules or similar are available,
          # see https://github.com/NixOS/nixpkgs/pull/254790
          checkedWarningItemType =
            let
              check = x: x ? condition && x ? message;
            in
            lib.types.addCheck warningItemType check;

          nestedWarningAttrsType =
            with lib.types;
            let
              isBranchNode = x: x == { } || lib.any lib.isAttrs (lib.attrValues x);

              nestedWarningItemType =
                (oneOf [
                  checkedWarningItemType
                  (addCheck (attrsOf nestedWarningItemType) isBranchNode)
                ])
                // {
                  description = "nested attrs of (${warningItemType.description})";
                };
            in
            nestedWarningItemType;

          # Backwards compatibility for warnings that are still written as strings inside a list.
          # The attribute name will be set to the sha256 sum of the warning message, e.g. `warnings."<sha256>" = { ... }`
          coercedWarningAttrs =
            let
              coerce = xs: {
                legacy = lib.listToAttrs (
                  map (
                    message:
                    lib.nameValuePair (builtins.hashString "sha256" message) {
                      inherit message;
                      condition = true;
                    }
                  ) xs
                );
              };
            in
            with lib.types;
            coercedTo (listOf str) coerce (
              submodule (
                { config, ... }: {
                  freeformType = nestedWarningAttrsType;
                  options = {
                    __flattened = lib.mkOption {
                      type = listOf str;
                      internal = true;
                      description = ''
                        All triggered warnings collected down to a flat list of strings as
                        expected by `lib.asserts.checkAssertWarn`.
                      '';
                    };
                  };

                  config.__flattened = lib.mkForce (
                    let
                      warningItems = collect' (x: lib.isAttrs x && x ? condition && x ? enable && x ? message) (
                        removeAttrs config [
                          "__flattened"
                          "_module"
                        ]
                      );

                      triggeredWarnings = lib.filter (
                        x: x.value.enable == true && x.value.condition == true && lib.isString x.value.message
                      ) warningItems;
                    in
                    map (x: "warnings." + (lib.showAttrPath x.path) + ":\n" + x.value.message) triggeredWarnings
                  );
                }
              )
            );
        in
        coercedWarningAttrs;
      internal = true;
      default = { };
      example = lib.literalExpression ''
        {
          services.foo.deprecationNotice = {
            condition = config.services.foo.enable;
            message = "The `foo' service is deprecated and will go away soon!";
          };
          services.bar.otherWarning = {
            condition = !config.services.bar.settings.importantOption;
            message = "You might want to enable services.bar.settings.importantOption, or everything is going to break";
          };
        }
      '';
      description = ''
        This option allows modules to show warnings to users during
        the evaluation of the system configuration.
      '';
    };
  };
  # impl of assertions is in
  # - <nixpkgs/nixos/modules/system/activation/top-level.nix>
  # - <nixpkgs/lib/services/lib.nix>
}
