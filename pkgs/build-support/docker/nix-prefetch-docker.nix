{
  lib,
  stdenv,
  makeWrapper,
  nix,
  skopeo,
  jq,
  coreutils,
}:

stdenv.mkDerivation {
  name = "nix-prefetch-docker";

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    install -vD ${./nix-prefetch-docker} $out/bin/$name;
    wrapProgram $out/bin/$name \
      --prefix PATH : ${
        lib.makeBinPath [
          nix
          skopeo
          jq
          coreutils
        ]
      } \
      --set HOME /homeless-shelter
  '';

  meta = with lib; {
    description = "Script used to obtain source hashes for dockerTools.pullImage";
    mainProgram = "nix-prefetch-docker";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
