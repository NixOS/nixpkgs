{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  pandoc,
  vim,
  neovim-unwrapped,
  makeWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "panvimdoc";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "panvimdoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fr7OEeVNhxbNAMJYlyhMnle+HPPPv7HVRWMadkyi4z4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    find scripts -maxdepth 1 -type f -exec install -Dm444 {} -t $out/share/scripts \;
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Write documentation in pandoc markdown. Generate documentation in vimdoc";
    homepage = "https://github.com/kdheepak/panvimdoc";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mrcjkb ];
    mainProgram = "panvimdoc";
  };
})
