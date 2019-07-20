import ./make-test.nix ({ pkgs, ... }:
  let
    track = pkgs.fetchurl {
      # Sourced from http://freemusicarchive.org/music/Blue_Wave_Theory/Surf_Music_Month_Challenge/Skyhawk_Beach_fade_in
      # License: http://creativecommons.org/licenses/by-sa/4.0/

      name = "Blue_Wave_Theory-Skyhawk_Beach.mp3";
      url = https://freemusicarchive.org/file/music/ccCommunity/Blue_Wave_Theory/Surf_Music_Month_Challenge/Blue_Wave_Theory_-_04_-_Skyhawk_Beach.mp3;
      sha256 = "0xw417bxkx4gqqy139bb21yldi37xx8xjfxrwaqa0gyw19dl6mgp";
    };

    defaultCfg = rec {
      user = "mpd";
      group = "mpd";
      dataDir = "/var/lib/mpd";
      musicDirectory = "${dataDir}/music";
    };

    defaultMpdCfg = with defaultCfg; {
      inherit dataDir musicDirectory user group;
      enable = true;
    };

    musicService = { user, group, musicDirectory }: {
      description = "Sets up the music file(s) for MPD to use.";
      requires = [ "mpd.service" ];
      after = [ "mpd.service" ];
      wantedBy = [ "default.target" ];
      script = ''
        mkdir -p ${musicDirectory} && chown -R ${user}:${group} ${musicDirectory}
        cp ${track} ${musicDirectory}
        chown ${user}:${group} ${musicDirectory}/$(basename ${track})
      '';
    };

    mkServer = { mpd, musicService, }:
      { boot.kernelModules = [ "snd-dummy" ];
        sound.enable = true;
        services.mpd = mpd;
        systemd.services.musicService = musicService;
      };
  in {
    name = "mpd";
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ emmanuelrosa ];
    };

  nodes =
    { client = 
      { ... }: { };

      serverALSA =
        { ... }: (mkServer {
          mpd = defaultMpdCfg // {
            network.listenAddress = "any";
            extraConfig = ''
              audio_output {
                type "alsa"
                name "ALSA"
                mixer_type "null"
              }
            '';
          };

          musicService = with defaultMpdCfg; musicService { inherit user group musicDirectory; };
        }) // { networking.firewall.allowedTCPPorts = [ 6600 ]; };

      serverPulseAudio =
        { ... }: (mkServer {
          mpd = defaultMpdCfg // {
            extraConfig = ''
              audio_output {
                type "pulse"
                name "The Pulse"
              }
            '';
          };

          musicService = with defaultCfg; musicService { inherit user group musicDirectory; };
        }) // { hardware.pulseaudio.enable = true; };
    };

  testScript = ''
    my $mpc = "${pkgs.mpc_cli}/bin/mpc --wait";

    # Connects to the given server and attempts to play a tune.
    sub play_some_music {
        my $server = $_[0];

        $server->waitForUnit("mpd.service");
        $server->succeed("$mpc update");
        my @tracks = $server->execute("$mpc ls");

        for my $track (split(/\n/, $tracks[1])) {
            $server->succeed("$mpc add $track");
        };

        my @added_tracks = $server->execute("$mpc listall");
        (length $added_tracks[1]) > 0 or die "Failed to add audio tracks to the playlist.";

        $server->succeed("$mpc play");

        my @status = $server->execute("$mpc status");
        my @output = split(/\n/, $status[1]);
        $output[1] =~ /.*playing.*/ or die "Audio track is not playing, as expected.";

        $server->succeed("$mpc stop");
    };

    play_some_music($serverALSA);
    play_some_music($serverPulseAudio);

    $client->succeed("$mpc -h serverALSA status");

    # The PulseAudio-based server is configured not to accept external client connections
    # to perform the following test:
    $client->fail("$mpc -h serverPulseAudio status");
  '';
})
