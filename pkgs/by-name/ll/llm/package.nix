# The `...` allows this derivation to be overridden with `enable-<llm-plugin>`.
#
# Example:
#
# ```nix
# llm.override {
#    enable-llm-anthropic = true;
#    enable-llm-gemini = true;
#    enable-llm-cmd = true;
#    enable-llm-templates-github = true;
# }
# ```
#
# Whatever names are accepted by `llm.withPlugins` are accepted with an added `enable-` prefix as
# an override of this derivation. The user can also do `llm.withPlugins { llm-anthropic = true; }`.
{ lib, python3Packages, ... }@args:

let
  inherit (python3Packages) llm;

  hasEnablePrefix = lib.hasPrefix "enable-";
  addEnablePrefix = name: "enable-${name}";
  removeEnablePrefix = lib.removePrefix "enable-";

  # Filter to just the attributes which are named "enable-<plugin-name>"
  enableArgs = lib.filterAttrs (name: value: hasEnablePrefix name) args;
  pluginArgs = lib.mapAttrs' (
    name: value: lib.nameValuePair (removeEnablePrefix name) value
  ) enableArgs;

  # Provide some diagnostics for the plugin names
  pluginNames = lib.attrNames (lib.functionArgs llm.withPlugins);
  enableNames = lib.map addEnablePrefix pluginNames;
  unknownPluginNames = lib.removeAttrs pluginArgs pluginNames;
  unknownNames = lib.map addEnablePrefix (lib.attrNames unknownPluginNames);
  unknownNamesDiagnostic = ''
    Unknown plugins specified in override: ${lib.concatStringsSep ", " unknownNames}

    Valid overrides:
      - ${lib.concatStringsSep "\n  - " enableNames}
  '';
in

assert lib.assertMsg (lib.length unknownNames == 0) unknownNamesDiagnostic;

llm.withPlugins pluginArgs
