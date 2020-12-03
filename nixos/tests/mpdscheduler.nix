import ./make-test-python.nix ({ pkgs, ... } :
let
  track = pkgs.fetchurl {
    # Sourced from http://freemusicarchive.org/music/Blue_Wave_Theory/Surf_Music_Month_Challenge/Skyhawk_Beach_fade_in
    # License: http://creativecommons.org/licenses/by-sa/4.0/

    name = "Blue_Wave_Theory-Skyhawk_Beach.mp3";
    url = "https://files.freemusicarchive.org/storage-freemusicarchive-org/music/ccCommunity/Blue_Wave_Theory/Surf_Music_Month_Challenge/Blue_Wave_Theory_-_04_-_Skyhawk_Beach.mp3";
    sha256 = "0xw417bxkx4gqqy139bb21yldi37xx8xjfxrwaqa0gyw19dl6mgp";
  };
in {
  name = "mpdscheduler";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ aberDerBart ];
  };

  nodes = {
    mpdWithSchedulerHost = { config, pkgs, ... }: {
      boot.kernelModules = [ "snd-dummy" ];
      sound.enable = true;
      services.mpd = {
        enable = true;
        extraConfig = ''
          audio_output {
            type "alsa"
            name "alsa"
            mixer_type "null"
          }
          follow_outside_symlinks "yes"

          log_level "verbose"
        '';
      };
      # systemd.services.musicService = musicService {};
      systemd.tmpfiles.rules = [ "L /var/lib/mpd/music/skyhawk_beach.mp3 - - - - ${track}" ];
      services.mpdscheduler = {
        enable = true;
        fadeTime = 0;
      };

      environment.systemPackages = with pkgs; [
        mpc_cli
      ];

      networking.firewall.allowedTCPPorts = [ 6600 ];
    };

    mpdOnlyHost = { config, pkgs, ... }: {
      boot.kernelModules = [ "snd-dummy" ];
      sound.enable = true;
      services.mpd = {
        enable = true;
        network.listenAddress = "any";
      };

      environment.systemPackages = with pkgs; [
        mpc_cli
      ];

      networking.firewall.allowedTCPPorts = [ 6600 ];
    };

    mpdschedulerHost = { config, pkgs, ... }: {
      services.mpdscheduler = {
        enable = true;
        host = "mpdOnlyHost";
        additionalChannels = false;
      };
    };
  };

  testScript = ''
    mpc = "${pkgs.mpc_cli}/bin/mpc --wait"

    with subtest("Mpdscheduler running on the same machine, additionalChannels=true"):
        h = mpdWithSchedulerHost

        h.wait_for_unit("mpdscheduler.service")
        h.wait_for_unit("systemd-tmpfiles-setup.service")

        h.succeed(f"{mpc} update")

        # add a song to the playlist so mpd can play
        h.succeed(f"{mpc} listall | mpc add")

        # Check we succeeded adding audio tracks to the playlist
        _, added_tracks = h.execute(f"{mpc} playlist")
        # assert len(added_tracks.splitlines()) == 0

        # test alarm
        h.succeed(f"{mpc} sendmessage scheduler 'alarm +0'")
        # wait for mpdscheduler to do its work
        time.sleep(0.1)
        _, output = h.execute(f"{mpc} status")
        # Assure audio track is playing
        assert "playing" in output

        # test sleep
        h.succeed(f"{mpc} sendmessage scheduler 'sleep +0'")
        # wait for mpdscheduler to do its work
        time.sleep(0.1)
        _, output = h.execute(f"{mpc} status")
        # Assure audio track is paused
        assert "paused" in output

        # test additional channels
        h.succeed(f"{mpc} sendmessage alarm +1")
        h.succeed(f"{mpc} sendmessage sleep +1")
        h.succeed(f"{mpc} sendmessage cancel 1")
        h.succeed(f"{mpc} sendmessage cancel 0")

    with subtest("Mpdscheduler on different machine, additionalChannels=false"):
        h = mpdOnlyHost

        h.wait_for_unit("mpd.service")
        mpdschedulerHost.wait_for_unit("mpdscheduler.service")

        # test scheduler channel to be available
        h.succeed(f"{mpc} sendmessage scheduler 'alarm +1'")

        # test additional channels not to be available
        h.fail(f"{mpc} sendmessage alarm +1")
        h.fail(f"{mpc} sendmessage sleep +1")
        h.fail(f"{mpc} sendmessage cancel 0")

        # cancel pending alarm
        h.succeed(f"{mpc} sendmessage scheduler 'cancel 0'")
  '';
})

