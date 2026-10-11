{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
}:

buildNpmPackage rec {
  pname = "mainsail";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "mainsail-crew";
    repo = "mainsail";
    rev = "v${version}";
    hash = "sha256-LAwyC1r0I14rj3drtpIjHPn053tf/2fygEJJDrm56M4=";
  };

  npmDepsHash = "sha256-v0jUmMmvm1fLUmUpqqXE8DvLc/1WGjYm9UTB9jx+KrM=";

  nodejs = nodejs_22;

  # Prevent Cypress binary download.
  env.CYPRESS_INSTALL_BINARY = 0;

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

  meta = {
    description = "Web interface for managing and controlling 3D printers with Klipper";
    homepage = "https://docs.mainsail.xyz";
    changelog = "https://github.com/mainsail-crew/mainsail/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      lovesegfault
      wulfsta
    ];
  };
}
