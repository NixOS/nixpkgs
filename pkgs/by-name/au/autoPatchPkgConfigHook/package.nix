{
  lib,
  makeSetupHook,
  pkgconf,
  python3Minimal,
  replaceVars,
  glib,
}:
makeSetupHook {
  name = "auto-patch-pkg-config-hook";
  propagatedBuildInputs = [
    python3Minimal
  ];

  substitutions = {
    inherit (pkgconf) suffixSalt;
    PATCH_PC_SCRIPT = replaceVars ./patch-pc.py {
      PKG_CONFIG_BIN = lib.getExe pkgconf;
    };
  };

  # Pretty exntensive usage, decent test
  passthru.tests.glib = glib;

  meta = {
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.RossSmyth
    ];
  };
} ./hook.sh
