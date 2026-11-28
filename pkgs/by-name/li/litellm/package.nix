{
  lib,
  path,
  python3Packages,
}:

(python3Packages.toPythonApplication (
  python3Packages.litellm.overridePythonAttrs (oldAttrs: {
    dependencies =
      (oldAttrs.dependencies or [ ])
      ++ lib.concatAttrValues (
        lib.getAttrs [
          "proxy"
          "extra_proxy"
          "proxy-runtime"
        ] oldAttrs.optional-dependencies
      );
  })
)).overrideAttrs
  (
    finalAttrs: prevAttrs: {
      passthru = prevAttrs.passthru // {
        commandModules = lib.modules.commandTree {
          # In `modules`, not in this directory, so that the sandbox that builds
          # the option documentation contains it. See "Modules of a package" in
          # the Nixpkgs manual.
          directory = path + "/modules/generic/pkgs/by-name/li/litellm/commands";
          package = finalAttrs.finalPackage;
        };
      };
    }
  )
