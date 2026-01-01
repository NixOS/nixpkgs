{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "meme-image-generator";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "nomad-software";
    repo = "meme";
    rev = "v${version}";
    hash = "sha256-L+JpNg9X3RSNXTozv2H1n2JiQx75i9gFGaQmDFaMIf0=";
  };

  vendorHash = null;

<<<<<<< HEAD
  meta = {
    description = "Command line utility for creating image macro style memes";
    homepage = "https://github.com/nomad-software/meme";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.fgaz ];
=======
  meta = with lib; {
    description = "Command line utility for creating image macro style memes";
    homepage = "https://github.com/nomad-software/meme";
    license = licenses.mit;
    maintainers = [ maintainers.fgaz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "meme";
  };
}
