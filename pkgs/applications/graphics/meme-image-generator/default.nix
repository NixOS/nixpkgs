{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "meme-image-generator";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "nomad-software";
    repo = "meme";
    rev = "v${version}";
    hash = "sha256-MzSPJCszVEZkBvSbRzXR7AaDQOOjDQ2stKKJr8oGOSE=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "A command line utility for creating image macro style memes";
    homepage = "https://github.com/nomad-software/meme";
    license = licenses.mit;
    maintainers = [ maintainers.fgaz ];
  };
}
