{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  nixosTests,
  replaceVars,
  unstableGitUpdater,
}:
buildNimPackage (finalAttrs: rec {
  date = "2025-05-01";

  pname = "nitter";
  version = "0-unstable-${date}";

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "e40c61a6ae76431c570951cc4925f38523b00a82";
    hash = "sha256-YOwoN3sC5g9oV1gbIu2TQE4SCAoNDONvEQy9xvzKD/c=";
  };

  lockFile = ./lock.json;

  patches = [
    (replaceVars ./nitter-version.patch {
      version = lib.replaceString "-" "." date;
      rev = builtins.substring 0 7 finalAttrs.src.rev;
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
})
