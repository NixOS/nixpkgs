{
  lib,
  stdenv,
  makeWrapper,
  bash,
  coreutils,
  gnused,
  darcs,
  cacert,
  gawk,
  jq,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nix-prefetch-darcs";
  version = "1.0.0";

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  dontUnpack = true;

  installPhase = ''
    install -vD ${./nix-prefetch-darcs.sh} $out/bin/$pname;
    wrapProgram $out/bin/$pname --prefix PATH : ${
      lib.makeBinPath [
        darcs
        cacert
        gawk
        jq
        coreutils
        gnused
      ]
    } --set HOME /homeless-shelter
  '';

  preferLocalBuild = true;

  meta = {
    description = "Script used to obtain source hashes for fetchdarcs";
    maintainers = with lib.maintainers; [ bennofs ];
    platforms = lib.platforms.unix;
    mainProgram = "nix-prefetch-darcs";
  };
})
