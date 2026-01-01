{
  lib,
  buildGoModule,
  fetchFromGitHub,
  tmux,
  which,
  makeWrapper,
}:

buildGoModule rec {
  pname = "overmind";
  version = "2.5.1";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/overmind" --prefix PATH : "${
      lib.makeBinPath [
        tmux
        which
      ]
    }"
  '';

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = "overmind";
    rev = "v${version}";
    sha256 = "sha256-wX29nFmzmbxbaXtwIWZNvueXFv9SKIOqexkc5pEITpw=";
  };

  vendorHash = "sha256-XhF4oizOZ6g0351Q71Wp9IA3aFpocC5xGovDefIoL78=";

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/DarthSim/overmind";
    description = "Process manager for Procfile-based applications and tmux";
    mainProgram = "overmind";
    license = with lib.licenses; [ mit ];
=======
  meta = with lib; {
    homepage = "https://github.com/DarthSim/overmind";
    description = "Process manager for Procfile-based applications and tmux";
    mainProgram = "overmind";
    license = with licenses; [ mit ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
