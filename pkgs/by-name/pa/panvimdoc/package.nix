{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  pandoc,
  vim,
  neovim-unwrapped,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "panvimdoc";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "panvimdoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HmEBPkNELHC7Xy0v730sQWZyPPwFdIBUcELzNtrWwzQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    install -Dm444 scripts/* -t $out/share/scripts
    install -Dm444 lib/* -t $out/share/lib
    install -Dm755 panvimdoc.sh -t $out/share
    runHook postBuild
  '';

  postFixup = ''
    makeWrapper $out/share/panvimdoc.sh $out/bin/panvimdoc --prefix PATH : ${
      lib.makeBinPath [
        pandoc
        vim
        neovim-unwrapped
      ]
    }
  '';

  meta = {
    description = "Write documentation in pandoc markdown. Generate documentation in vimdoc";
    homepage = "https://github.com/kdheepak/panvimdoc";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mrcjkb ];
    mainProgram = "panvimdoc";
  };
})
