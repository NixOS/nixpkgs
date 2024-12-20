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
    version = "0-unstable-2024-02-26";

    src = fetchFromGitHub {
      owner = "zedeus";
      repo = "nitter";
      rev = "c6edec04901d0a37799499ed4c6921db640fb5a4";
      hash = "sha256-N3d63nyVzUTa2+UemA1REFfVsw6iOVU8xUlYraR55m4=";
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
      updateScript = unstableGitUpdater { branch = "guest_accounts"; };
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
