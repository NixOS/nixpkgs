{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "fluidd";
  version = "1.30.1";

  src = fetchFromGitHub {
    owner = "fluidd-core";
    repo = "fluidd";
    rev = "v${version}";
    hash = "sha256-jG6sjb3YcP5+1lr2N8UE201nOdnkiPjeS6Mep/RG+N0=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  npmDepsHash = "sha256-VrYjM9ficPOTn/Ezoir+ZHIK32wztYB9c6ZpC8tte1Q=";

  # Prevent Cypress binary download.
  CYPRESS_INSTALL_BINARY = 0;

  postPatch = ''
    # Retrieve the commit saved in the output directory.
    sed -e "s|.execSync('git rev-parse --short HEAD')|.execSync('cat COMMIT')|g" -i vite.config.inject-version.ts
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fluidd
    cp -r ./dist $out/share/fluidd/htdocs

    runHook postInstall
  '';

  meta = with lib; {
    description = "Klipper web interface";
    homepage = "https://docs.fluidd.xyz";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      zhaofengli
      wulfsta
    ];
  };
}
