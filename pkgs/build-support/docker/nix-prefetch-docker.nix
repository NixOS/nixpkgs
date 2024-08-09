{ lib, stdenv, makeWrapper, nix, skopeo, jq }:

stdenv.mkDerivation {
  name = "nix-prefetch-docker";

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -vD ${./nix-prefetch-docker} $out/bin/$name;
    wrapProgram $out/bin/$name \
      --prefix PATH : ${lib.makeBinPath [ nix skopeo jq ]} \
      --set HOME /homeless-shelter

    runHook postInstall
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "Script used to obtain source hashes for dockerTools.pullImage";
    mainProgram = "nix-prefetch-docker";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
