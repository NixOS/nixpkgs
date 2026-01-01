{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  nixosTests,
  replaceVars,
  unstableGitUpdater,
}:

buildNimPackage (
  finalAttrs: prevAttrs: {
    pname = "nitter";
<<<<<<< HEAD
    version = "0-unstable-2025-12-24";
=======
    version = "0-unstable-2025-10-12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    src = fetchFromGitHub {
      owner = "zedeus";
      repo = "nitter";
<<<<<<< HEAD
      rev = "a92e79ebc3581702dc427434a782a5fc1d28cc91";
      hash = "sha256-bCogvVO99HPiZZOMDd0IDBNGBKIZ+My493SnbK+6HxM=";
=======
      rev = "662ae90e2246c8a01c811f68750b7e5033e0fa69";
      hash = "sha256-icjbAG/VkhzgKO2dyJYL/yc1VrVmU25Ymkz/41Ckd3M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };

    lockFile = ./lock.json;

    patches = [
      (replaceVars ./nitter-version.patch {
        inherit (finalAttrs) version;
        inherit (finalAttrs.src) rev;
        url = builtins.replaceStrings [ "archive" ".tar.gz" ] [ "commit" "" ] finalAttrs.src.url;
      })
    ];

    postBuild = ''
      nim compile ${toString finalAttrs.nimFlags} -r tools/gencss
      nim compile ${toString finalAttrs.nimFlags} -r tools/rendermd
    '';

    postInstall = ''
      mkdir -p $out/share/nitter
      cp -r public $out/share/nitter/public
    '';

    passthru = {
      tests = { inherit (nixosTests) nitter; };
      updateScript = unstableGitUpdater { };
    };

<<<<<<< HEAD
    meta = {
      homepage = "https://github.com/zedeus/nitter";
      description = "Alternative Twitter front-end";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [
=======
    meta = with lib; {
      homepage = "https://github.com/zedeus/nitter";
      description = "Alternative Twitter front-end";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        erdnaxe
        infinidoge
      ];
      mainProgram = "nitter";
    };
  }
)
