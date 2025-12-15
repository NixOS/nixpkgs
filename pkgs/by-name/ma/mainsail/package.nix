{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "mainsail";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "mainsail-crew";
    repo = "mainsail";
    rev = "v${version}";
    hash = "sha256-JmN5VPj4h83gLx/UsT69mXFxyvCHir0tl7zN2Q7eMOc=";
  };

  npmDepsHash = "sha256-8rUhDo1l0oLENWwy56UzwlSGIBJtTPsH6w5OX8tnp6U=";

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
