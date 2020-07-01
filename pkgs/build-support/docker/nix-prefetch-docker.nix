{ stdenv, makeWrapper, nix, skopeo, jq }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "nix-prefetch-docker";

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    install -vD ${./nix-prefetch-docker} $out/bin/$name;
    wrapProgram $out/bin/$name \
      --prefix PATH : ${makeBinPath [ nix skopeo jq ]} \
      --set HOME /homeless-shelter
  '';

  preferLocalBuild = true;

  meta = {
    description = "Script used to obtain source hashes for dockerTools.pullImage";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
