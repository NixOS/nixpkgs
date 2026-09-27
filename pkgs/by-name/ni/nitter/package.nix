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
    version = "0-unstable-2026-09-07";

    src = fetchFromGitHub {
      owner = "zedeus";
      repo = "nitter";
      rev = "376f14908e27e095049bbbeb648e742501144010";
      hash = "sha256-zsfbQDvQjgRqhREJvIHwhSx4u5CnTmamKjpkGTbz9E4=";
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
