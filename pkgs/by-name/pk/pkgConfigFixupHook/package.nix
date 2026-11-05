{
  lib,
  makeSetupHook,
  pkg-config,
  glib,
}:
makeSetupHook {
  name = "pkg-config-fixup";

  propagatedBuildInputs = [
    pkg-config
  ];

  passthru.tests = {
    inherit glib;
  };

  meta = {
    maintainers = [
      lib.maintainers.RossSmyth
    ];

    license = lib.licenses.mit;
  };
} ./hook.sh
