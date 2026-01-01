{ pkgs, lib, ... }:
let
  track = pkgs.fetchurl {
<<<<<<< HEAD
    # Sourced from https://freemusicarchive.org/music/Jazz_at_Mladost_Club/Jazz_Night/Blue_bossa/

    name = "Blue bossa - Jazz at Miadost Club.mp3";
    url = "https://files.freemusicarchive.org/storage-freemusicarchive-org/music/no_curator/Jazz_at_Mladost_Club/Jazz_Night/Jazz_at_Mladost_Club_-_07_-_Blue_bossa.mp3?download=1&name=Jazz%20at%20Mladost%20Club%20-%20Blue%20bossa.mp3";
    hash = "sha256-cAG4nBuc97J3ZJc9cm/6vWTgnPL/Hfkar7cA3+89rto=";
    meta.license = lib.licenses.cc-by-sa-40;
  };

  defaultMpdCfg = {
    user = "mpd";
    group = "mpd";
    dataDir = "/var/lib/mpd";
=======
    # Sourced from http://freemusicarchive.org/music/Blue_Wave_Theory/Surf_Music_Month_Challenge/Skyhawk_Beach_fade_in

    name = "Blue_Wave_Theory-Skyhawk_Beach.mp3";
    url = "https://freemusicarchive.org/file/music/ccCommunity/Blue_Wave_Theory/Surf_Music_Month_Challenge/Blue_Wave_Theory_-_04_-_Skyhawk_Beach.mp3";
    hash = "sha256-91VDWwrcP6Cw4rk72VHvZ8RGfRBrpRE8xo/02dcJhHc=";
    meta.license = lib.licenses.cc-by-sa-40;
  };

  defaultCfg = rec {
    user = "mpd";
    group = "mpd";
    dataDir = "/var/lib/mpd";
    musicDirectory = "${dataDir}/music";
  };

  defaultMpdCfg = {
    inherit (defaultCfg)
      dataDir
      musicDirectory
      user
      group
      ;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    enable = true;
  };

  musicService =
    {
      user,
      group,
<<<<<<< HEAD
      dataDir,
=======
      musicDirectory,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    }:
    {
      description = "Sets up the music file(s) for MPD to use.";
      requires = [ "mpd.service" ];
      after = [ "mpd.service" ];
      wantedBy = [ "default.target" ];
      script = ''
<<<<<<< HEAD
        cp ${track} ${dataDir}/music
=======
        cp ${track} ${musicDirectory}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      '';
      serviceConfig = {
        User = user;
        Group = group;
      };
    };

  mkServer =
    { mpd, musicService }:
    {
      boot.kernelModules = [ "snd-dummy" ];
      services.mpd = mpd;
      systemd.services.musicService = musicService;
    };
in
{
  name = "mpd";
  meta = {
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      emmanuelrosa
      doronbehar
    ];
=======
    maintainers = with lib.maintainers; [ emmanuelrosa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nodes = {
    client = { ... }: { };

    serverALSA =
      { ... }:
      lib.mkMerge [
        (mkServer {
          mpd = defaultMpdCfg // {
<<<<<<< HEAD
            settings = {
              bind_to_address = "any";
              audio_output = [
                {
                  type = "alsa";
                  name = "ALSA";
                  mixer_type = "null";
                }
              ];
            };
            openFirewall = true;
          };
          musicService = musicService { inherit (defaultMpdCfg) user group dataDir; };
        })
=======
            network.listenAddress = "any";
            extraConfig = ''
              audio_output {
                type "alsa"
                name "ALSA"
                mixer_type "null"
              }
            '';
          };
          musicService = musicService { inherit (defaultMpdCfg) user group musicDirectory; };
        })
        { networking.firewall.allowedTCPPorts = [ 6600 ]; }
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      ];

    serverPulseAudio =
      { ... }:
      lib.mkMerge [
        (mkServer {
          mpd = defaultMpdCfg // {
<<<<<<< HEAD
            settings.audio_output = [
              {
                type = "pulse";
                name = "The Pulse";
              }
            ];
          };

          musicService = musicService { inherit (defaultMpdCfg) user group dataDir; };
=======
            extraConfig = ''
              audio_output {
                type "pulse"
                name "The Pulse"
              }
            '';
          };

          musicService = musicService { inherit (defaultMpdCfg) user group musicDirectory; };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        })
        {
          services.pulseaudio = {
            enable = true;
            systemWide = true;
            tcp.enable = true;
            tcp.anonymousClients.allowAll = true;
          };
          systemd.services.mpd.environment.PULSE_SERVER = "localhost";
        }
      ];
  };

  testScript = ''
    mpc = "${lib.getExe pkgs.mpc} --wait"

    # Connects to the given server and attempts to play a tune.
    def play_some_music(server):
        server.wait_for_unit("mpd.service")
        server.succeed(f"{mpc} update")
        _, tracks = server.execute(f"{mpc} ls")

        for track in tracks.splitlines():
            server.succeed(f"{mpc} add {track}")

        _, added_tracks = server.execute(f"{mpc} playlist")

        # Check we succeeded adding audio tracks to the playlist
        assert len(added_tracks.splitlines()) > 0

        server.succeed(f"{mpc} play")

        _, output = server.execute(f"{mpc} status")
        # Assure audio track is playing
        assert "playing" in output

        server.succeed(f"{mpc} stop")


    play_some_music(serverALSA)
    play_some_music(serverPulseAudio)

    client.wait_for_unit("multi-user.target")
    client.succeed(f"{mpc} -h serverALSA status")

    # The PulseAudio-based server is configured not to accept external client connections
    # to perform the following test:
    client.fail(f"{mpc} -h serverPulseAudio status")
<<<<<<< HEAD
    # For inspecting these files
    serverALSA.copy_from_vm("/run/mpd/mpd.conf", "ALSA")
    serverPulseAudio.copy_from_vm("/run/mpd/mpd.conf", "PulseAudio")
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';
}
