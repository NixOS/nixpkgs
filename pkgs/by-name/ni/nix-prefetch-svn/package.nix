{
  lib,
  stdenv,
  makeWrapper,
  bash,
  coreutils,
  gnused,
  subversion,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nix-prefetch-svn";
  version = "1.0.0";

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  dontUnpack = true;

  installPhase = ''
    install -vD ${./nix-prefetch-svn.sh} $out/bin/$pname;
    wrapProgram $out/bin/$pname --prefix PATH : ${
      lib.makeBinPath [
        subversion
        coreutils
        gnused
      ]
    } --set HOME /homeless-shelter
  '';

  preferLocalBuild = true;

  meta = {
    description = "Script used to obtain source hashes for fetchsvn";
    maintainers = with lib.maintainers; [ bennofs ];
    platforms = lib.platforms.unix;
    mainProgram = "nix-prefetch-svn";
  };
})
