{
  pkgs,
  self,
  lib,
  ...
}:

let
  testPort = 6969;
  testPassword = "testpass";
in
{
  name = "festival-server";

  nodes.machine =
    { config, pkgs, ... }:
    {
      boot.kernelModules = [ "snd-aloop" ];

      programs.festival = {
        enable = true;
        defaultVoice = v: v.kal_diphone;
      };

      # tests:
      # - if the server works
      # - if the port is correct
      # - if extraSiteInit works
      # - if the festival_client can produce audio
      services.festival = {
        enable = true;
        port = testPort;
        extraSiteInit = ''(set! server_passwd "${toString testPassword}")'';
      };

      environment.systemPackages = [ pkgs.alsa-utils ];

      users.users.machine = {
        isNormalUser = true;
        linger = true;
        password = "machine";
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    # Dump the journal before trying anything, to see why it auto-started and failed
    machine.succeed("su - machine -c 'journalctl --user -xeu festival.service --no-pager' || true")

    # Reset the start-limit so we can try again cleanly
    machine.systemctl("reset-failed festival.service", "machine")
    machine.systemctl("start festival.service", "machine")
    machine.wait_for_unit("festival.service", "machine")

    # Port test — note the closing quote was missing before
    machine.succeed(
      "su - machine -c 'journalctl --user --no-pager -o cat'"
      " | grep -qE 'Festival server started on port ${toString testPort}'"
    )

    # Wrong password attempt
    machine.execute(
      "echo 'Festival test.' | festival_client"
      " --port ${toString testPort} --passwd wrongpass"
      " --ttw --otype riff --output /tmp/noauth.wav || true"
    )

    # Server should have logged a rejection
    machine.succeed(
      "su - machine -c 'journalctl --user --no-pager -o cat'"
      " | grep -q 'rejected'"
    )

    # Festival Client test
    machine.succeed(
      "echo 'Festival test. Festival test.' | festival_client"
      " --port ${toString testPort} --passwd ${toString testPassword}"
      " --ttw --otype riff --output /tmp/tts-out.wav"
    )
    size = int(machine.succeed("stat -c %s /tmp/tts-out.wav").strip())
    assert size > 10000, f"Festival WAV too small: {size} bytes"

    machine.fail(
      "su - machine -c 'journalctl --user --no-pager -o cat'"
      " | grep -qE 'command not found|Cannot load wavefile|SIOD ERROR'"
    )
  '';
}
