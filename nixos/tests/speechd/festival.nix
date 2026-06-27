{
  pkgs,
  self,
  lib,
  ...
}:

{
  name = "speechd-festival";

  nodes.machine =
    { config, pkgs, ... }:
    {
      boot.kernelModules = [ "snd-aloop" ];

      programs.festival = {
        enable = true;
        defaultVoice = v: v.kal_diphone;
        extraVoices = voices: with voices; [ kal_diphone ];
        speechdSupport = true;
      };

      services.festival.enable = true;
      services.speechd.enable = true;

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

    # Dump user journal to help debug if festival fails to start
    machine.succeed("su - machine -c 'journalctl --user -xeu festival.service --no-pager' || true")

    machine.systemctl("reset-failed festival.service", "machine")
    machine.systemctl("start festival.service", "machine")
    machine.wait_for_unit("festival.service", "machine")

    machine.systemctl("start speech-dispatcher.service", "machine")
    machine.wait_for_unit("speech-dispatcher.service", "machine")

    # Direct Festival test
    machine.succeed(
      "echo '(utt.save.wave (utt.synth (Utterance Text \"Festival test. Festival test.\")) \"/tmp/tts-out.wav\" (quote riff))' | festival --pipe"
    )
    size = int(machine.succeed("stat -c %s /tmp/tts-out.wav").strip())
    assert size > 44, f"Festival WAV too small: {size} bytes"

    # spd-say test: record the loopback while spd-say speaks
    machine.execute("arecord -D hw:Loopback,1,0 -f S16_LE -r 16000 -c 1 -d 10 /tmp/spd-out.wav &")
    machine.sleep(1)

    machine.succeed("spd-say -o festival -w 'Test from Speech Dispatcher via Festival. Second sentence.'")

    machine.sleep(2)

    spd_size = int(machine.succeed("stat -c %s /tmp/spd-out.wav").strip())
    assert spd_size > 100_000, f"spd→festival WAV too small, likely no audio: {spd_size} bytes"

    machine.fail(
      "su - machine -c 'journalctl --user --no-pager -o cat'"
      " | grep -qE 'command not found|Cannot load wavefile|SIOD ERROR'"
    )

    print("✅ speechd-festival test passed")
  '';
}
