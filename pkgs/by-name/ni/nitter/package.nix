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
    version = "0-unstable-2025-02-25";

    src = fetchFromGitHub {
      owner = "zedeus";
      repo = "nitter";
      rev = "41fa47bfbf3917e9b3ac4f7b49c89a75a7a2bd44";
      hash = "sha256-cmYlmzCJl1405TuYExGw3AOmjdY0r7ObmmLCAom+Fyw=";
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

    meta = with lib; {
      homepage = "https://github.com/zedeus/nitter";
      description = "Alternative Twitter front-end";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [
        erdnaxe
        infinidoge
      ];
      mainProgram = "nitter";
    };
  }
)
