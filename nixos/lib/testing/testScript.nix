testModuleArgs@{ config, lib, hostPkgs, nodes, moduleType, ... }:
let
  inherit (lib) mkOption types;
  inherit (types) either str functionTo;
in
{
  options = {
    testScript = mkOption {
      type = either str (functionTo str);
      description = ''
        A series of python declarations and statements that you write to perform
        the test.
      '';
    };
    testScriptString = mkOption {
      type = str;
      readOnly = true;
      internal = true;
    };

    includeTestScriptReferences = mkOption {
      type = types.bool;
      default = true;
      internal = true;
    };
    withoutTestScriptReferences = mkOption {
      type = moduleType;
      description = ''
        A parallel universe where the testScript is invalid and has no references.
      '';
      internal = true;
      visible = false;
    };
  };
  config = {
    withoutTestScriptReferences.includeTestScriptReferences = false;
    withoutTestScriptReferences.testScript = lib.mkForce "testscript omitted";

    testScriptString =
      if lib.isFunction config.testScript
      then
        config.testScript
          {
            nodes =
              lib.mapAttrs
                (k: v:
                  if v.virtualisation.useNixStoreImage
                  then
                  # prevent infinite recursion when testScript would
                  # reference v's toplevel
                    config.withoutTestScriptReferences.nodesCompat.${k}
                  else
                  # reuse memoized config
                    v
                )
                config.nodesCompat;
          }
      else config.testScript;

    defaults = { config, name, ... }: {
      # Make sure all derivations referenced by the test
      # script are available on the nodes. When the store is
      # accessed through 9p, this isn't important, since
      # everything in the store is available to the guest,
      # but when building a root image it is, as all paths
      # that should be available to the guest has to be
      # copied to the image.
      virtualisation.additionalPaths =
        lib.optional
          # A testScript may evaluate nodes, which has caused
          # infinite recursions. The demand cycle involves:
          #   testScript -->
          #   nodes -->
          #   toplevel -->
          #   additionalPaths -->
          #   hasContext testScript' -->
          #   testScript (ad infinitum)
          # If we don't need to build an image, we can break this
          # cycle by short-circuiting when useNixStoreImage is false.
          (config.virtualisation.useNixStoreImage && builtins.hasContext testModuleArgs.config.testScriptString && testModuleArgs.config.includeTestScriptReferences)
          (hostPkgs.writeStringReferencesToFile testModuleArgs.config.testScriptString);
    };
  };
}
