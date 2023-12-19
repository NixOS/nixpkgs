{ lib
, buildNimPackage
, fetchFromGitHub
, nixosTests
, substituteAll
, unstableGitUpdater
}:

buildNimPackage (finalAttrs: prevAttrs: {
  pname = "nitter";
  version = "unstable-2023-12-03";

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "583c858cdf3486451ed6a0627640844f27009dbe";
    hash = "sha256-3E6nfmOFhQ2bjwGMWdTmZ38Fg/SE36s6fxYDXwSJaTw=";
  };

  lockFile = ./lock.json;

  patches = [
    (substituteAll {
      src = ./nitter-version.patch;
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
    updateScript = unstableGitUpdater {};
  };

  meta = with lib; {
    homepage = "https://github.com/zedeus/nitter";
    description = "Alternative Twitter front-end";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ erdnaxe infinidoge ];
    mainProgram = "nitter";
  };
})
