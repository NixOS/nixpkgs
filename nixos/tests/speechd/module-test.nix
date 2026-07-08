{
  lib,
  defaultModule,
  moduleConfig ? { },
  otherModules ? { },
  extraModulesConfig ? { },
  extraConfigLines ? "",
  extraChecks ? "",
  audioOutputMethod ? [ "libao" ],
  extraNodeConfig ? { },
}:
{
  name = "speechd-${defaultModule}-${lib.concatStringsSep "-" audioOutputMethod}";

  nodes.machine =
    { config, pkgs, ... }:
    lib.recursiveUpdate {
      boot.kernelModules = [ "snd-aloop" ];

      services.speechd = {
        enable = true;
        modules =
          otherModules
          // lib.optionalAttrs (moduleConfig != null) {
            ${defaultModule} = {
              enable = true;
            }
            // moduleConfig;
          };
        extraModules = extraModulesConfig;
        defaultModule = defaultModule;
        audioOutputMethod = audioOutputMethod;
        logLevel = 5;
        logDir = "/tmp/speech-debug";
        extraConfig = extraConfigLines;
      };

      environment.systemPackages = [
        pkgs.alsa-utils
      ];

      users.users.machine = {
        isNormalUser = true;
        linger = true;
        password = "machine";
      };
    } extraNodeConfig;

  testScript =
    { nodes, ... }:
    let
      logDir = nodes.machine.services.speechd.logDir;
    in
    ''
      import re

      machine.start()
      machine.wait_for_unit("multi-user.target")

      machine.systemctl("reset-failed speech-dispatcher.service", "machine")
      machine.systemctl("start speech-dispatcher.service", "machine")
      machine.wait_for_unit("speech-dispatcher.service", "machine")

      # --- Module test ---
      machine.wait_until_succeeds(
        "su - machine -c 'XDG_RUNTIME_DIR=/run/user/1000 spd-say -O | grep -q \"${defaultModule}\"'",
        timeout=30,
      )

      # --- Log directory and Catch Start ---
      machine.succeed("test -d ${logDir}")
      machine.succeed("test -n \"$(ls ${logDir})\"")

      # --- Sound Icons Test ---
      machine.execute("arecord -D hw:Loopback,1,0 -f S16_LE -r 16000 -c 1 -d 5 /tmp/sound-icon-out.wav &")
      machine.sleep(1)
      status, out = machine.execute(
        "su - machine -c 'XDG_RUNTIME_DIR=/run/user/1000 spd-say -I message' 2>&1"
      )
      print(f"sound_icon exit={status}\n{out}")
      machine.sleep(2)
      icon_size = int(machine.succeed("stat -c %s /tmp/sound-icon-out.wav").strip())
      assert icon_size > 1_000, f"sound icon produced no audio: {icon_size} bytes"

      # --- Audio output test ---
      machine.execute("arecord -D hw:Loopback,1,0 -f S16_LE -r 16000 -c 1 -d 10 /tmp/spd-out.wav &")
      machine.sleep(1)

      machine.wait_until_succeeds("su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 spd-say -o ${defaultModule} -w 'Test a single sentence.'\"",
        timeout=30,
      )
      machine.wait_until_succeeds("su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 spd-say -o ${defaultModule} -w 'Test from Speech Dispatcher via ${defaultModule}. Second sentence.'\"",
        timeout=30,
      )
      machine.sleep(2)
      spd_size = int(machine.succeed("stat -c %s /tmp/spd-out.wav").strip())
      assert spd_size > 100_000, f"spd→${defaultModule} WAV too small, likely no audio: {spd_size} bytes"

      # --- Rate / pitch / volume options ---
      machine.succeed("su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 spd-say -o ${defaultModule} -r 50 -w 'Fast speech rate test.'\"")
      machine.succeed("su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 spd-say -o ${defaultModule} -r -50 -w 'Slow speech rate test.'\"")
      machine.succeed("su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 spd-say -o ${defaultModule} -p 50 -w 'High pitch test.'\"")
      machine.succeed("su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 spd-say -o ${defaultModule} -i 50 -w 'High volume test.'\"")

      # --- Log directory and content ---
      machine.succeed("test -d ${logDir}")
      machine.succeed("test -n \"$(ls ${logDir})\"")
      machine.succeed("ls ${logDir}/${defaultModule}.log")

      # --- No fatal errors in journal ---
      journal = machine.succeed("su - machine -c 'journalctl --user --no-pager -o cat'")
      pattern = re.compile(
        r"Unknown Config-Option|Could not initialize engine|has no voice|"
        r"Failed to set synthesis voice|Failed to set punctuation list|FATAL|core dumped",
        re.IGNORECASE,
      )
      matches = [line for line in journal.splitlines() if pattern.search(line)]
      if matches:
        print("Found problem lines:\n" + "\n".join(matches))
        raise AssertionError("Found error patterns in journal")

      ${extraChecks}
    '';
}
