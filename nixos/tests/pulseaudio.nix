let
  mkTest = { systemWide ? false }:
    import ./make-test-python.nix ({ pkgs, lib, ... }:
      let
        testFile = pkgs.fetchurl {
          url =
            "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3";
          hash = "sha256-+iggJW8s0/LfA/okfXsB550/55Q0Sq3OoIzuBrzOPJQ=";
        };

        makeTestPlay = key:
          { sox, alsa-utils }:
          pkgs.writeScriptBin key ''
            set -euxo pipefail
            ${sox}/bin/play ${testFile}
            ${sox}/bin/sox ${testFile} -t wav - | ${alsa-utils}/bin/aplay
            touch /tmp/${key}_success
          '';

        testers = builtins.mapAttrs makeTestPlay {
          testPlay = { inherit (pkgs) sox alsa-utils; };
          testPlay32 = { inherit (pkgs.pkgsi686Linux) sox alsa-utils; };
        };
      in {
        name = "pulseaudio${lib.optionalString systemWide "-systemWide"}";
        meta = with pkgs.lib.maintainers; {
          maintainers = [ synthetica ] ++ pkgs.pulseaudio.meta.maintainers;
        };

        nodes.machine = { ... }:

          {
            imports = [ ./common/wayland-cage.nix ];
            hardware.pulseaudio = {
              enable = true;
              support32Bit = true;
              inherit systemWide;
            };

            environment.systemPackages = [ testers.testPlay pkgs.pavucontrol ]
              ++ lib.optional pkgs.stdenv.isx86_64 testers.testPlay32;
          } // lib.optionalAttrs systemWide {
            users.users.alice.extraGroups = [ "audio" ];
            systemd.services.pulseaudio.wantedBy = [ "multi-user.target" ];
          };

        enableOCR = true;

        testScript = { ... }: ''
          machine.wait_until_succeeds("pgrep xterm")
          machine.wait_for_text("alice@machine")

          machine.send_chars("testPlay \n")
          machine.wait_for_file("/tmp/testPlay_success")
          ${lib.optionalString pkgs.stdenv.isx86_64 ''
            machine.send_chars("testPlay32 \n")
            machine.wait_for_file("/tmp/testPlay32_success")
          ''}
          machine.screenshot("testPlay")

          # Pavucontrol only loads when Pulseaudio is running. If it isn't, the
          # text "Playback" (one of the tabs) will never show.
          machine.send_chars("pavucontrol\n")
          machine.wait_for_text("Playback")
          machine.screenshot("Pavucontrol")
        '';
      });
in builtins.mapAttrs (key: val: mkTest val) {
  user = { systemWide = false; };
  system = { systemWide = true; };
}
