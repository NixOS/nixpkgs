{ pkgs, lib, ... }:
let
  track = pkgs.fetchurl {
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
    enable = true;
  };

  musicService =
    {
      user,
      group,
      dataDir,
    }:
    {
      description = "Sets up the music file(s) for MPD to use.";
      requires = [ "mpd.service" ];
      after = [ "mpd.service" ];
      wantedBy = [ "default.target" ];
      script = ''
        cp ${track} ${dataDir}/music
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
    maintainers = with lib.maintainers; [
      emmanuelrosa
      doronbehar
    ];
  };

  nodes = {
    client = { ... }: { };

    serverALSA =
      { ... }:
      lib.mkMerge [
        (mkServer {
          mpd = defaultMpdCfg // {
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
      ];

    serverPulseAudio =
      { ... }:
      lib.mkMerge [
        (mkServer {
          mpd = defaultMpdCfg // {
            settings.audio_output = [
              {
                type = "pulse";
                name = "The Pulse";
              }
            ];
          };

          musicService = musicService { inherit (defaultMpdCfg) user group dataDir; };
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
    # For inspecting these files
    serverALSA.copy_from_vm("/run/mpd/mpd.conf", "ALSA")
    serverPulseAudio.copy_from_vm("/run/mpd/mpd.conf", "PulseAudio")
  '';
}
