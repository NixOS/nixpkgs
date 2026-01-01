{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage (finalAttrs: {
  pname = "freifunk-meshviewer";

<<<<<<< HEAD
  version = "12.8.0";
=======
  version = "12.7.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "freifunk";
    repo = "meshviewer";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    sha256 = "sha256-M0ZTGH6MW8admkHvbFTgCHbRIlpDkgvSzaIfv7rDiyA=";
  };

  npmDepsHash = "sha256-zrXhdR2k8HHvPBid004WtyZYPDWuRggSIkKcLVdb8Lc=";
=======
    sha256 = "sha256-nle99URK1s8v+fatpf9D0dIOIp6BKeaEYZ1PijLkt9A=";
  };

  npmDepsHash = "sha256-6XUe55X1WDPNldPRlgqG1C7CuGyYrS2vSiLmoza3QIs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  installPhase = ''
    mkdir -p $out/share/freifunk-meshviewer/
    cp -r build/* $out/share/freifunk-meshviewer/
  '';

  meta = {
    homepage = "https://github.com/freifunk/meshviewer";
    changelog = "https://github.com/freifunk/meshviewer/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      felixsinger
    ];
    license = lib.licenses.agpl3Only;
  };
})
