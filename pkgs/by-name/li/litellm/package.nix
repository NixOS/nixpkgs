{ python3Packages }:

let
  litellm = python3Packages.litellm;
in
python3Packages.toPythonApplication (
  litellm.overridePythonAttrs (oldAttrs: {
    dependencies =
      (oldAttrs.dependencies or [ ])
      ++ litellm.optional-dependencies.proxy
      ++ litellm.optional-dependencies.extra_proxy;
  })
)
