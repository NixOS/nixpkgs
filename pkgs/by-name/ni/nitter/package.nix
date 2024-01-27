{ lib
, buildNimPackage
, fetchFromGitHub
, nixosTests
, substituteAll
, unstableGitUpdater
}:

buildNimPackage (finalAttrs: prevAttrs: {
  pname = "nitter";
  version = "unstable-2024-01-12";

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "52db03b73ad5f83f67c83ab197ae3b20a2523d39";
    hash = "sha256-Jp8iix6VUeepigGx+eeJUTQeZfSJ3tSc/TAa5AMfG2U=";
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
    updateScript = unstableGitUpdater { branch = "guest_accounts"; };
  };

  meta = with lib; {
    homepage = "https://github.com/zedeus/nitter";
    description = "Alternative Twitter front-end";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ erdnaxe infinidoge ];
    mainProgram = "nitter";
  };
})
