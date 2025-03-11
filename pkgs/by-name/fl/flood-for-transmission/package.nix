# To use this package, use: `services.transmission.webHome = pkgs.flood-for-transmission;`
{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "flood-for-transmission";
  version = "2024-11-16T12-26-17";

  src = fetchFromGitHub {
    owner = "johman10";
    repo = "flood-for-transmission";
    tag = version;
    hash = "sha256-OED2Ypi1V+wwnJ5KFVRbJAyh/oTYs90E6uhSnSwJwJU=";
  };

  npmDepsHash = "sha256-J3gRzvSXXyoS0OoLrTSV1vBSupFqky0Jt99nyz+hy1k=";

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    cp -r public $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Flood clone for Transmission";
    homepage = "https://github.com/johman10/flood-for-transmission";
    downloadPage = "https://github.com/johman10/flood-for-transmission/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ al3xtjames ];
    platforms = platforms.all;
  };
}
