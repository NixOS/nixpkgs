{
  lib,
  stdenv,
  makeWrapper,
  bash,
  coreutils,
  gnused,
  breezy,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nix-prefetch-bzr";
  version = "1.0.0";

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  dontUnpack = true;

  installPhase = ''
    install -vD ${./nix-prefetch-bzr.sh} $out/bin/$pname;
    wrapProgram $out/bin/$pname --prefix PATH : ${
      lib.makeBinPath [
        breezy
        coreutils
        gnused
      ]
    } --set HOME /homeless-shelter
  '';

  preferLocalBuild = true;

  meta = {
    description = "Script used to obtain source hashes for fetchbzr";
    maintainers = with lib.maintainers; [ bennofs ];
    platforms = lib.platforms.unix;
    mainProgram = "nix-prefetch-bzr";
  };
})
