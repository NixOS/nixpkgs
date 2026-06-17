{
  lib,
  stdenv,
  makeSetupHook,
}:
makeSetupHook {
  name = "add-driver-runpath-hook";

  substitutions = {
    # Named "opengl-driver" for legacy reasons, but it is the path to
    # hardware drivers installed by NixOS
    driverLink = "/run/opengl-driver" + lib.optionalString stdenv.hostPlatform.isi686 "-32";
  };
} ./setup-hook.sh
