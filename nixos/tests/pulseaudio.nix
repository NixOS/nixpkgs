let
  mkTest = { systemWide ? false , fullVersion ? false }:
    import ./make-test-python.nix ({ pkgs, lib, ... }:
      let
        testFile = pkgs.fetchurl {
          url =
            "https://file-examples.com/storage/fe5947fd2362fc197a3c2df/2017/11/file_example_MP3_700KB.mp3";
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
        name = "pulseaudio${lib.optionalString fullVersion "Full"}${lib.optionalString systemWide "-systemWide"}";
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
            } // lib.optionalAttrs fullVersion {
              package = pkgs.pulseaudioFull;
            };

            environment.systemPackages = [ testers.testPlay pkgs.pavucontrol ]
              ++ lib.optional pkgs.stdenv.hostPlatform.isx86_64 testers.testPlay32;
          } // lib.optionalAttrs systemWide {
            users.users.alice.extraGroups = [ "pulse-access" ];
            systemd.services.pulseaudio.wantedBy = [ "multi-user.target" ];
          };

        enableOCR = true;

        testScript = { ... }: ''
          machine.wait_until_succeeds("pgrep xterm")
          machine.wait_for_text("alice@machine")

          machine.send_chars("testPlay \n")
          machine.wait_for_file("/tmp/testPlay_success")
          ${lib.optionalString pkgs.stdenv.hostPlatform.isx86_64 ''
            machine.send_chars("testPlay32 \n")
            machine.wait_for_file("/tmp/testPlay32_success")
          ''}
          machine.screenshot("testPlay")

          ${lib.optionalString (!systemWide) ''
            machine.send_chars("pacmd info && touch /tmp/pacmd_success\n")
            machine.wait_for_file("/tmp/pacmd_success")
          ''}

          # Pavucontrol only loads when Pulseaudio is running. If it isn't, the
          # text "Dummy Output" (sound device name) will never show.
          machine.send_chars("pavucontrol\n")
          machine.wait_for_text("Dummy Output")
          machine.screenshot("Pavucontrol")
        '';
      });
in builtins.mapAttrs (key: val: mkTest val) {
  user = { systemWide = false; fullVersion = false; };
  system = { systemWide = true; fullVersion = false; };
  userFull = { systemWide = false; fullVersion = true; };
  systemFull = { systemWide = true; fullVersion = true; };
}
