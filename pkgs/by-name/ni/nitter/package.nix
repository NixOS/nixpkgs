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
    version = "0-unstable-2025-04-05";

    src = fetchFromGitHub {
      owner = "zedeus";
      repo = "nitter";
      rev = "83b0f8b55ae7bfb8a19a0bf14de52f30d06b8db6";
      hash = "sha256-2QIcAhzYrIo1q80959980H+hzLYtPHAOy0+CItDZ1d4=";
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
