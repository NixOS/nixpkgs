{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  npm-lockfile-fix,
}:

buildNpmPackage {
  pname = "niimblue";
  version = "0-unstable-2026-05-04";

  src = fetchFromGitHub {
    owner = "MultiMote";
    repo = "niimblue";
    rev = "89aed31a5162b282d2100dd2c2e3d90584153e41";
    hash = "sha256-3Vrph+AVBLDSlP29JfYrPBjmpBCiM+EtApthelEBggc=";
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r dist/* $out
    runHook postInstall
  '';

  __structuredAttrs = true;

  npmDepsHash = "sha256-+jVD0lfOrQ3hQE15yfcB0dVnPZBFo/naLXhFRiPFUGs=`";

  meta = {
    description = "Design and print labels with NIIMBOT printers directly from your PC or mobile web browser";
    homepage = "https://github.com/MultiMote/niimblue";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "niimblue";
    platforms = lib.platforms.all;
  };
}
