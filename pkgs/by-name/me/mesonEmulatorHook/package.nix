# While building documentation, meson may want to run binaries for host, which needs an emulator.
# Example of an error which this fixes
# [Errno 8] Exec format error: './gdk3-scan'
{
  lib,
  stdenv,
  makeSetupHook,
  writeText,
  pkgs,
}:

let
  hook =
    assert lib.assertMsg (!stdenv.hostPlatform.canExecute stdenv.targetPlatform)
      "mesonEmulatorHook may only be added to nativeBuildInputs when the target binaries can't be executed; however you are attempting to use it in a situation where ${stdenv.hostPlatform.config} can execute ${stdenv.targetPlatform.config}. Consider only adding mesonEmulatorHook according to a conditional based canExecute in your package expression.";
    ./hook.sh;
in

makeSetupHook {
  name = "mesonEmulatorHook";
  substitutions = {
    crossFile = writeText "cross-file.conf" ''
      [binaries]
      exe_wrapper = '${lib.escape [ "'" "\\" ] (stdenv.targetPlatform.emulator pkgs)}'
    '';
  };
} hook
