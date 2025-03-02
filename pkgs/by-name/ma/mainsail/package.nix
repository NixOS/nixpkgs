{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "mainsail";
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "mainsail-crew";
    repo = "mainsail";
    rev = "v${version}";
    hash = "sha256-rXavUkoFRw5fWCisdz/eD+wL1Sc+vExyjskVEIN4QNQ=";
  };

  npmDepsHash = "sha256-MzPXDy9sX7Y5dUm3qp3OORdEz8QyL5j4M4eXl0gtopo=";

  # Prevent Cypress binary download.
  CYPRESS_INSTALL_BINARY = 0;

  preConfigure = ''
    # Make the build.zip target do nothing, since we will just copy these files later.
    sed -e 's/"build.zip":.*,$/"build.zip": "",/g' -i package.json
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r ./dist $out/share/mainsail

    runHook postInstall
  '';

  meta = with lib; {
    description = "Web interface for managing and controlling 3D printers with Klipper";
    homepage = "https://docs.mainsail.xyz";
    changelog = "https://github.com/mainsail-crew/mainsail/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      shhht
      lovesegfault
      wulfsta
    ];
  };
}
