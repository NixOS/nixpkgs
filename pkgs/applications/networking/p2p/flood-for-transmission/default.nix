# To use this package, use: `services.transmission.webHome = pkgs.flood-for-transmission;`
{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "flood-for-transmission";
  version = "2024-02-10T19-10-27";

  src = fetchFromGitHub {
    owner = "johman10";
    repo = pname;
    rev = version;
    hash = "sha256-JhUBtjHWtfFwjOScDu+WtjE42yhWYPA6KD+kJsltbsY=";
  };

  npmDepsHash = "sha256-VHWM0vxFKucrmoJiwYpjw7QqhBQw9rPPQVIIevp6Wn0=";

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
