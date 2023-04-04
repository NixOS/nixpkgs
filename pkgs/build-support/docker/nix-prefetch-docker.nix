{ lib, callPackage, stdenv, makeWrapper, nix, skopeo, jq }:

stdenv.mkDerivation (finalAttrs: {
  name = "nix-prefetch-docker";

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    install -vD ${./nix-prefetch-docker} $out/bin/$name;
    wrapProgram $out/bin/$name \
      --prefix PATH : ${lib.makeBinPath [ nix skopeo jq ]} \
      --set HOME /homeless-shelter
  '';

  preferLocalBuild = true;

  passthru = {
    fetch = callPackage ./test/fetchDocker.nix {
      nix-prefetch-docker = finalAttrs.finalPackage;
    };
    tests = callPackage ./test/fetchDocker-tests.nix {
      nix-prefetch-docker = finalAttrs.finalPackage;
      fetchDocker = finalAttrs.finalPackage.fetch;
    };
  };

  meta = with lib; {
    description = "Script used to obtain source hashes for dockerTools.pullImage";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
})
