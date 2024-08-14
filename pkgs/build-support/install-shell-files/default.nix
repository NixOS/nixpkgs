{ makeSetupHook, tests }:

# See the header comment in ./setup-hook.sh for example usage.
let
  setupHook = makeSetupHook { name = "install-shell-files"; } ./setup-hook.sh;
in

setupHook.overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or {}) // {
    tests = tests.install-shell-files;
  };
})
