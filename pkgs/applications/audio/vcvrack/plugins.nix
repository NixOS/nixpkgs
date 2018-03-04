{ fetchFromGitHub }:

{
  Fundamental = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Fundamental";
    rev = "760f6ea76f9dc01af832932343eb427a95cde775";
    sha256 = "18mmijjf4qj18bhpmbxhkw3km43a6a8sfk5wd48y2pda7i64zqhq";
    fetchSubmodules = true;
  };
  AudibleInstruments = fetchFromGitHub {
    owner = "VCVRack";
    repo = "AudibleInstruments";
    rev = "2fc0a0589b3d7b091d4cb7c3392a9deca202bb71";
    sha256 = "0dadbmbxcifn60fw1cjni9v95jb9hlimncq8h4l1gisf9nxl7cwl";
    fetchSubmodules = true;
  };
  Befaco = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Befaco";
    rev = "e80a5bc922c3c6a75fadd326eeb64761c76592bf";
    sha256 = "0bki1miapllw6hyhngwchq3p7rmnxvm4afs5knr6v038ib3m0cfd";
    fetchSubmodules = true;
  };
  ESeries = fetchFromGitHub {
    owner = "VCVRack";
    repo = "ESeries";
    rev = "6c6c75528859a7464ed22a9e6131b77ea6f6b9ea";
    sha256 = "03xdkwmdnpf709wqb6dx0xd66nzrxp7x6i9wlqjr0zv3604cd3y9";
    fetchSubmodules = true;
  };

  # Does not compile because it requires samplerate.h, which got removed in recent releases of vcvrack.
  # AepelzensModules = fetchFromGitHub {
  #   owner = "Aepelzen";
  #   repo = "AepelzensModules";
  #   rev = "61c686389c56af1a05acbf62abb10f434ec83027";
  #   sha256 = "0lyb5zpajvv1mkl1a71jgs7yfnw522h8lb0ckx05bkqhsgzi5qzm";
  #   fetchSubmodules = true;
  # };

  # AepelzensParasites = fetchFromGitHub {
  #   owner = "Aepelzen";
  #   repo = "AepelzensParasites";
  #   rev = "b8ae026f79f46928d01754374f58d08ea4f85cdc";
  #   sha256 = "1raj5cghd9lybz6n334968zf08an8mw7i8hsaw29vrj5847hfxbr";
  #   fetchSubmodules = true;
  # };


}
