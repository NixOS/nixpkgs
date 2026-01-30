{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_20,
}:

buildNpmPackage rec {
  pname = "mainsail";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "mainsail-crew";
    repo = "mainsail";
    rev = "v${version}";
    hash = "sha256-lKLoY5FHO34bT/3apmfVkuW0E1h4/K4r2thF9ht03U4=";
  };

  npmDepsHash = "sha256-HIErBrQ0VP4vdCFZe7uT5b1q+QdSSf08CIQmNcSryZ8=";

  nodejs = nodejs_20;

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

  meta = {
    description = "Web interface for managing and controlling 3D printers with Klipper";
    homepage = "https://docs.mainsail.xyz";
    changelog = "https://github.com/mainsail-crew/mainsail/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      shhht
      lovesegfault
      wulfsta
    ];
  };
}
