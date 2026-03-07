{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  stdenv,
}:

buildNpmPackage rec {
  pname = "cinny-unwrapped";
  # Remember to update cinny-desktop when bumping this version.
  version = "4.10.5";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    tag = "v${version}";
    hash = "sha256-Napy3AcsLRDZPcBh3oq1U30FNtvoNtob0+AZtZSvcbM=";
  };

  nodejs = nodejs_22;

  npmDepsHash = "sha256-2Lrd0jAwAH6HkwLHyivqwaEhcpFAIALuno+MchSIfxo=";

  # Skip rebuilding native modules since they're not needed for the web app
  npmRebuildFlags = [
    "--ignore-scripts"
  ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  meta = {
    description = "Yet another Matrix client for the web";
    homepage = "https://cinny.in/";
    maintainers = with lib.maintainers; [
      abbe
      rebmit
    ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
  };
}
