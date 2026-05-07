{
  lib,
  buildGoModule,
  fetchFromGitHub,
  tmux,
  which,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
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
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-wX29nFmzmbxbaXtwIWZNvueXFv9SKIOqexkc5pEITpw=";
  };

  vendorHash = "sha256-XhF4oizOZ6g0351Q71Wp9IA3aFpocC5xGovDefIoL78=";

  meta = {
    homepage = "https://github.com/DarthSim/overmind";
    description = "Process manager for Procfile-based applications and tmux";
    mainProgram = "overmind";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
  };
})
