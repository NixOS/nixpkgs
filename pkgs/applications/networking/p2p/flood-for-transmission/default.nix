# To use this package, use: `services.transmission.webHome = pkgs.flood-for-transmission;`
{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "flood-for-transmission";
  version = "2024-05-18T08-04-58";

  src = fetchFromGitHub {
    owner = "johman10";
    repo = "flood-for-transmission";
    rev = version;
    hash = "sha256-/vD53tFvCBOU9i/EfogjNjCEp6BBkR6eEKWnPhCUdJk=";
  };

  npmDepsHash = "sha256-BKr4Gm3bTFnxgv4HlPclr8+c6jDVPFFbGXvpk5t8/X4=";

  installPhase = ''
    runHook preInstall

    cp -r public $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Flood clone for Transmission";
    homepage = "https://github.com/johman10/flood-for-transmission";
    maintainers = with maintainers; [ al3xtjames ];
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
