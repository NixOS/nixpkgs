{
  lib,
  stdenv,
  makeWrapper,
  bash,
  coreutils,
  gnused,
  cvs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nix-prefetch-cvs";
  version = "1.0.0";

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  dontUnpack = true;

  installPhase = ''
    install -vD ${./nix-prefetch-cvs.sh} $out/bin/$pname;
    wrapProgram $out/bin/$pname --prefix PATH : ${
      lib.makeBinPath [
        cvs
        coreutils
        gnused
      ]
    } --set HOME /homeless-shelter
  '';

  preferLocalBuild = true;

  meta = {
    description = "Script used to obtain source hashes for fetchcvs";
    maintainers = with lib.maintainers; [ bennofs ];
    platforms = lib.platforms.unix;
    mainProgram = "nix-prefetch-cvs";
  };
})
