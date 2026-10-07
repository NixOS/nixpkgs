{ python3Packages }:

let
  pythonPackages = python3Packages.overrideScope (
    self: super: {
      mcp = self.mcp_2;
    }
  );
  litellm = pythonPackages.litellm;
in
pythonPackages.toPythonApplication (
  litellm.overridePythonAttrs (oldAttrs: {
    dependencies =
      (oldAttrs.dependencies or [ ])
      ++ litellm.optional-dependencies.proxy
      ++ litellm.optional-dependencies.extra_proxy
      ++ litellm.optional-dependencies.proxy-runtime;
  })
)
