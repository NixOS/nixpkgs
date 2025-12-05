{
  lib,
  stdenv,
  makeWrapper,
  bash,
  coreutils,
  gnused,
  mercurial,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nix-prefetch-hg";
  version = "1.0.0";

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  dontUnpack = true;

  installPhase = ''
    install -vD ${./nix-prefetch-hg.sh} $out/bin/$pname;
    wrapProgram $out/bin/$pname --prefix PATH : ${
      lib.makeBinPath [
        mercurial
        coreutils
        gnused
      ]
    } --set HOME /homeless-shelter
  '';

  preferLocalBuild = true;

  meta = {
    description = "Script used to obtain source hashes for fetchhg";
    maintainers = with lib.maintainers; [ bennofs ];
    platforms = lib.platforms.unix;
    mainProgram = "nix-prefetch-hg";
  };
})
