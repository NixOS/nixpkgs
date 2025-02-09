# To use this package, use: `services.transmission.webHome = pkgs.flood-for-transmission;`
{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "flood-for-transmission";
  version = "2023-11-17T12-46-13";

  src = fetchFromGitHub {
    owner = "johman10";
    repo = pname;
    rev = version;
    hash = "sha256-TaLWhly/4hOigWY1XP7FmgN4LbrdLb79NQ47z5JiiYE=";
  };

  npmDepsHash = "sha256-PCeknfS81K8ttU4hV2D841tgQsGfIVaAOVIEDXe8fVQ=";

  npmInstallFlags = [ "--legacy-peer-deps" ];

  installPhase = ''
    runHook preInstall

    cp -r public $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Flood clone for Transmission";
    homepage = "https://github.com/johman10/flood-for-transmission";
    maintainers = with maintainers; [ al3xtjames ];
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
