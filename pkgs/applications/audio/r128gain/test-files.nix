{ stdenvNoCC, lib, fetchurl, symlinkJoin }:
let
  inherit (builtins) baseNameOf;
  inherit (lib) concatMapStrings imap0;

  files = [
    {
      url = "https://upload.wikimedia.org/wikipedia/en/0/09/Opeth_-_Deliverance.ogg";
      hash = "sha256-8YejxLVznB7HMxpljOnnLeHtWgtHvt90EWKf15ns318=";
    }
    {
      name = "ehren-paper_lights-64.opus";
      url = "https://www.dropbox.com/s/xlp1goezxovlgl4/ehren-paper_lights-64.opus?dl=1";
      hash = "sha256-JdLGp1rNEL8KKjzW+JrflDw3h8R488wI2F4gtSvzz6I=";
    }
    {
      url = "http://www.largesound.com/ashborytour/sound/brobob.mp3";
      hash = "sha256-4mTxxnBCssGasC7bM0GK0kBiTdtawoD8bN2v7L+bQAM=";
    }
    {
      name = "Death%20Star.mp3";
      url = "https://www.dropbox.com/s/bdm7wyqaj3ij8ci/Death%20Star.mp3?dl=1";
      hash = "sha256-GyJenUtB7dZ9HJyMJdSK8I8qjJBy/UQnA9ZP30TXyVA=";
    }
    {
      url = "https://auphonic.com/media/audio-examples/01.auphonic-demo-unprocessed.m4a";
      hash = "sha256-AoPg9VdjAesutoDAQsiY5vuXwbOe4Izfw1k8E3ExeZ8=";
    }
    {
      url = "http://helpguide.sony.net/high-res/sample1/v1/data/Sample_HisokanaMizugame_88_2kHz24bit.flac.zip";
      hash = "sha256-w/UseJCRn3+/65557naWPoUQaVTtibXqQT/YP18KqeM=";
    }
    {
      url = "https://github.com/desbma/r128gain/files/3006101/snippet_with_high_true_peak.zip";
      hash = "sha256-g7z1wr9vFu6FkzRHUz2VzW0/Oivb2nBudhtXZK/t/iM=";
    }
    {
      name = "04-There%27s%20No%20Other%20Way.mp3";
      url = "https://www.dropbox.com/s/hnkmioxwu56dgs0/04-There%27s%20No%20Other%20Way.mp3?dl=1";
      hash = "sha256-uIHTk405nwjN1wggZD4XDLoFY22LyJnjc9sE5wecxQw=";
    }
  ];

  srcs = imap0
    (i: args: fetchurl (args // {
      # Massaging the URLs into a name Nix accepts takes some effort
      # that wouldn't help people looking at their /nix/store, so we
      # just generate a deterministic (and descriptive) name.
      name = "r128gain-test-file-${toString i}";
      passthru.realName = args.name or (baseNameOf args.url);
    }))
    files;
in
stdenvNoCC.mkDerivation {
  pname = "r128gain-test-cache";
  version = "1.0.3";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    ${concatMapStrings (src: ''
    install -m644 ${src} $out/${src.realName}
    '') srcs}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Test files for r128gain";
    homepage = "https://github.com/desbma/r128gain";
    license = licenses.unfree;
    maintainers = [ maintainers.AluisioASG ];
    platforms = platforms.all;
  };
}
