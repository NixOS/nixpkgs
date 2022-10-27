import ./make-test-python.nix ({ pkgs, firefoxPackage, ... }:
let firefoxPackage' = firefoxPackage.override (args: {
      extraPrefsFiles = (args.extraPrefsFiles or []) ++ [
        # make sure that autoplay is enabled by default for the audio test
        (builtins.toString (builtins.toFile "autoplay-pref.js" ''defaultPref("media.autoplay.default",0);''))
      ];
  });

in
{
  name = firefoxPackage'.unwrapped.pname;
  meta = with pkgs.lib.maintainers; {
    maintainers = [ eelco shlevy ];
  };

  nodes.machine =
    { pkgs, ... }:

    { imports = [ ./common/x11.nix ];
      environment.systemPackages = [
        firefoxPackage'
        pkgs.xdotool
      ];

      # Create a virtual sound device, with mixing
      # and all, for recording audio.
      boot.kernelModules = [ "snd-aloop" ];
      sound.enable = true;
      sound.extraConfig = ''
        pcm.!default {
          type plug
          slave.pcm pcm.dmixer
        }
        pcm.dmixer {
          type dmix
          ipc_key 1
          slave {
            pcm "hw:Loopback,0,0"
            rate 48000
            periods 128
            period_time 0
            period_size 1024
            buffer_size 8192
          }
        }
        pcm.recorder {
          type hw
          card "Loopback"
          device 1
          subdevice 0
        }
      '';

      systemd.services.audio-recorder = {
        description = "Record NixOS test audio to /tmp/record.wav";
        script = "${pkgs.alsa-utils}/bin/arecord -D recorder -f S16_LE -r48000 /tmp/record.wav";
      };

    };

  testScript = ''
      from contextlib import contextmanager


      @contextmanager
      def record_audio(machine: Machine):
          """
          Perform actions while recording the
          machine audio output.
          """
          machine.systemctl("start audio-recorder")
          yield
          machine.systemctl("stop audio-recorder")


      def wait_for_sound(machine: Machine):
          """
          Wait until any sound has been emitted.
          """
          machine.wait_for_file("/tmp/record.wav")
          while True:
              # Get at most 2M of the recording
              machine.execute("tail -c 2M /tmp/record.wav > /tmp/last")
              # Get the exact size
              size = int(machine.succeed("stat -c '%s' /tmp/last").strip())
              # Compare it against /dev/zero using `cmp` (skipping 50B of WAVE header).
              # If some non-NULL bytes are found it returns 1.
              status, output = machine.execute(
                  f"cmp -i 50 -n {size - 50} /tmp/last /dev/zero 2>&1"
              )
              if status == 1:
                  break
              machine.sleep(2)


      machine.wait_for_x()

      with subtest("Wait until Firefox has finished loading the Valgrind docs page"):
          machine.execute(
              "xterm -e '${firefoxPackage'.unwrapped.binaryName} file://${pkgs.valgrind.doc}/share/doc/valgrind/html/index.html' >&2 &"
          )
          machine.wait_for_window("Valgrind")
          machine.sleep(40)

      with subtest("Check whether Firefox can play sound"):
          with record_audio(machine):
              machine.succeed(
                  "${firefoxPackage'.unwrapped.binaryName} file://${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/phone-incoming-call.oga >&2 &"
              )
              wait_for_sound(machine)
          machine.copy_from_vm("/tmp/record.wav")

      with subtest("Close sound test tab"):
          machine.execute("xdotool key ctrl+w")

      with subtest("Close default browser prompt"):
          machine.execute("xdotool key space")

      with subtest("Wait until Firefox draws the developer tool panel"):
          machine.sleep(10)
          machine.succeed("xwininfo -root -tree | grep Valgrind")
          machine.screenshot("screen")
    '';

})
