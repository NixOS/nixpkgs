{
  fetchFromGitHub,
  lib,
  buildNpmPackage,
  electron,
  nodejs,
  fetchpatch,
}:

buildNpmPackage rec {
  pname = "antares";
  version = "0.7.28";

  src = fetchFromGitHub {
    owner = "antares-sql";
    repo = "antares";
    rev = "v${version}";
    hash = "sha256-nEI1G0A1c+xjALbIcItzh4CFxAeQPOD8h+Bs0aYnEfU=";
  };

  npmDepsHash = "sha256-lSkZTa2zt8BeucOih8XjQ7QW/tg34umIRe4a4DDBW34=";

  patches = [
    # In version 0.7.28, package-lock is not updated properly so this patch update it to be able to build the package
    # This patch will probably be removed in the next version
    ./npm-lock.patch
  ];

  buildInputs = [ nodejs ];

  npmBuildScript = "compile";

  installPhase = ''
    runHook preInstall
    npmInstallHook
    cp -rf dist/* $out/lib/node_modules/antares
    find -name "*.ts" | xargs rm -f
    makeWrapper ${lib.getExe electron} $out/bin/antares \
      --add-flags $out/lib/node_modules/antares/main.js
    runHook postInstall
  '';

  npmFlags = [ "--legacy-peer-deps" ];
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  meta = with lib; {
    description = "Modern, fast and productivity driven SQL client with a focus in UX";
    homepage = "https://github.com/antares-sql/antares";
    license = licenses.mit;
    maintainers = with maintainers; [ eymeric ];
  };
}
