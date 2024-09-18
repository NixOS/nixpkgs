{ lib
, buildNpmPackage
, fetchFromGitHub
}:

 buildNpmPackage rec {
  pname = "mainsail";
  version = "2.12.0";

  src = fetchFromGitHub {
      owner = "mainsail-crew";
      repo = "mainsail";
      rev = "v${version}";
      hash = "sha256-ZRs+KhHNQIGXy/3MUNM5OUuWSntfjYsW3d0OOvuvdAQ=";
  };

  npmDepsHash = "sha256-du1X58wUTelgJO/0JYwxfHjjNpu1e4M1GDvx6tgz8Zw=";

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
    maintainers = with maintainers; [ shhht lovesegfault wulfsta ];
  };
}
