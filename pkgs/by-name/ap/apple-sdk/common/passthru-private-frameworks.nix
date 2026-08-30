{
  lib,
  makeSetupHook,
  sdkVersion,
}:

self: super: {
  passthru = super.passthru or { } // {
    privateFrameworksHook = makeSetupHook {
      name = "apple-sdk-private-frameworks-hook";
      meta.license = lib.licenses.mit;
    } ../setup-hooks/add-private-frameworks.sh;
  };
}
