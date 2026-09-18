{
  lib,
  configFiles,
  path,
  python3Packages,
}:

let
  # In `modules`, not in this directory, so that the sandbox that builds the
  # option documentation contains it. See "Modules of a package" in the Nixpkgs
  # manual.
  genericModules = path + "/modules/generic/pkgs/by-name/li/litellm";
in

python3Packages.toPythonApplication (
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

    passthru = (oldAttrs.passthru or { }) // {
      configFiles = configFiles (import (genericModules + "/config-files.nix"));
      configModule = genericModules + "/config-module.nix";
    };
  })
)
