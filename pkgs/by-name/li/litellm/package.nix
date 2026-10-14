{ lib, python3Packages }:

python3Packages.toPythonApplication (
  python3Packages.litellm.overridePythonAttrs (oldAttrs: {
    dependencies =
      oldAttrs.dependencies
      ++ lib.concatMap (extra: oldAttrs.optional-dependencies.${extra}) [
        "proxy"
        "extra_proxy"
        "proxy-runtime"
      ];
  })
)
