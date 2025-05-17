{
  heimdall,
  lib,
  runCommandLocal,
}:

runCommandLocal "heimdall-udev-rules"
  {
    inherit (heimdall) version src;

    meta =
      (builtins.removeAttrs heimdall.meta [
        "broken"
        "mainProgram"
      ])
      // {
        description = "udev rules for download mode on Samsung mobile devices";
        platforms = lib.platforms.linux;
      };
  }
  ''
    mkdir -p $out/lib/udev/rules.d
    install -m644 -t $out/lib/udev/rules.d $src/heimdall/60-heimdall.rules
  ''
