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
    version = "0-unstable-2026-03-15";

    src = fetchFromGitHub {
      owner = "zedeus";
      repo = "nitter";
      rev = "7ce29bd8f1725a95b091abb2ede174edd167f1ad";
      hash = "sha256-ut0NagKxYVdByVFr95Vp7ml92BrW10G0Gsy4dU/odKA=";
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

    meta = {
      homepage = "https://github.com/zedeus/nitter";
      description = "Alternative Twitter front-end";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [
        erdnaxe
        infinidoge
      ];
      mainProgram = "nitter";
    };
  }
)
