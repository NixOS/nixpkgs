{
  lib,
  configFiles,
  python3Packages,
}:

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
      configFiles = configFiles (import ./config-files.nix);
    };
  })
)
