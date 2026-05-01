{ lib, ... }:
let
  port = 59126;
in
{
  name = "marytts";
  meta.maintainers = with lib.maintainers; [ pluiedev ];

  nodes.machine =
    { pkgs, ... }:
    {
      networking.firewall.enable = false;
      networking.useDHCP = false;

      services.marytts = {
        enable = true;
        inherit port;

        voices = [
          (pkgs.fetchzip {
            url = "https://github.com/marytts/voice-bits1-hsmm/releases/download/v5.2/voice-bits1-hsmm-5.2.zip";
            hash = "sha256-1nK+qZxjumMev7z5lgKr660NCKH5FDwvZ9sw/YYYeaA=";
          })
        ];

        userDictionaries = [
          (pkgs.writeTextFile {
            name = "userdict-en_US.txt";
            destination = "/userdict-en_US.txt";
            text = ''
              amogus | @ - ' m @U - g @ s
              Nixpkgs | n I k s - ' p { - k @ - dZ @ s
            '';
          })
        ];
      };
    };

  testScript = ''
    from xml.etree import ElementTree
    from urllib.parse import urlencode

    machine.wait_for_unit("marytts.service")

    with subtest("Checking health of MaryTTS server"):
      machine.wait_for_open_port(${toString port})
      assert 'Mary TTS server' in machine.succeed("curl 'localhost:${toString port}/version'")

    with subtest("Generating example MaryXML"):
      query = urlencode({
        'datatype': 'RAWMARYXML',
        'locale': 'en_US',
      })
      xml = machine.succeed(f"curl 'localhost:${toString port}/exampletext?{query}'")
      root = ElementTree.fromstring(xml)
      text = " ".join(root.itertext()).strip()
      assert text == "Welcome to the world of speech synthesis!"

    with subtest("Detecting custom voice"):
      assert "bits1-hsmm" in machine.succeed("curl 'localhost:${toString port}/voices'")

    with subtest("Finding user dictionary"):
      query = urlencode({
        'INPUT_TEXT': 'amogus',
        'INPUT_TYPE': 'TEXT',
        'OUTPUT_TYPE': 'PHONEMES',
        'LOCALE': 'en_US',
      })
      phonemes = machine.succeed(f"curl 'localhost:${toString port}/process?{query}'")
      phonemes_tree = ElementTree.fromstring(phonemes)
      print([i.get('ph') for i in phonemes_tree.iter('{http://mary.dfki.de/2002/MaryXML}t')])
      assert ["@ - ' m @U - g @ s"] == [i.get('ph') for i in phonemes_tree.iter('{http://mary.dfki.de/2002/MaryXML}t')]

    with subtest("Synthesizing"):
      query = urlencode({
        'INPUT_TEXT': 'Nixpkgs is a collection of over 100,000 software packages that can be installed with the Nix package manager.',
        'INPUT_TYPE': 'TEXT',
        'OUTPUT_TYPE': 'AUDIO',
        'AUDIO': 'WAVE_FILE',
        'LOCALE': 'en_US',
      })
      machine.succeed(f"curl 'localhost:${toString port}/process?{query}' -o ./audio.wav")
      machine.copy_from_vm("./audio.wav")
  '';
}
