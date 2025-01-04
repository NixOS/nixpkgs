import ../make-test-python.nix (
  { pkgs, ... }:
  {

    name = "timidity-with-vorbis";

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          (timidity.override { enableVorbis = true; })
          ffmpeg # # for `ffprobe`
        ];
      };

    testScript = ''
      import json

      start_all()

      ## TiMidity++ is around and it claims to support Ogg Vorbis.
      machine.succeed("command -v timidity")
      machine.succeed("timidity --help | grep 'Ogg Vorbis'")

      ## TiMidity++ manages to process a MIDI input and produces an Ogg Vorbis
      ## output file. NOTE: the `timidity` CLI succeeds even when the input file
      ## does not exist; hence our test for the output file's existence.
      machine.succeed("cp ${./tam-lin.midi} tam-lin.midi")
      machine.succeed("timidity -Ov tam-lin.midi && test -e tam-lin.ogg")

      ## The output file has the expected characteristics.
      metadata_as_text = machine.succeed("ffprobe -show_format -print_format json -i tam-lin.ogg")
      metadata = json.loads(metadata_as_text)
      assert metadata['format']['format_name'] == 'ogg', \
          f"expected 'format_name' to be 'ogg', got '{metadata['format']['format_name']}'"
      assert 37 <= float(metadata['format']['duration']) <= 38, \
          f"expected 'duration' to be between 37s and 38s, got {metadata['format']['duration']}s"
    '';
  }
)
