{ makeSetupHook, tests }:

# See the header comment in ../setup-hooks/install-shell-files.sh for example usage.
let
  setupHook = makeSetupHook { name = "install-shell-files"; } ../setup-hooks/install-shell-files.sh;
in

setupHook.overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or { }) // {
    tests = tests.install-shell-files;
  };
})
