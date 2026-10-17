{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
}:

buildNpmPackage rec {
  pname = "mainsail";
  version = "2.18.2";

  src = fetchFromGitHub {
    owner = "mainsail-crew";
    repo = "mainsail";
    rev = "v${version}";
    hash = "sha256-Djw5wwVflhU9G99GLUNO0a6wDZTB4y/yBqRruUJZQis=";
  };

  npmDepsHash = "sha256-fQnAVwBME4oJ15sOmZAr4qwxSpA5qqr8zJxEsVVGwSg=";

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
