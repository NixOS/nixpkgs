{ fetchFromGitHub
, lib
, buildNpmPackage
, electron
, nodejs
}:

buildNpmPackage rec {
  pname = "antares";
  version = "0.7.22";

  src = fetchFromGitHub {
    owner = "antares-sql";
    repo = "antares";
    rev = "v${version}";
    hash = "sha256-SYnhrwxoyVw+bwfN1PGMsoul+mTfi8UkiP0fNOvVTBc=";
  };

  npmDepsHash = "sha256-5khFw8Igu2d5SYLh7OiCpUDMOVH5gAje+VnvoESQboo=";

  buildInputs = [ nodejs ];

  buildPhase = ''
    runHook preBuild
    npm run compile
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    npmInstallHook
    cp -rf dist/* $out/lib/node_modules/antares
    find -name "*.ts" | xargs rm -f
    makeWrapper ${lib.getExe electron} $out/bin/antares \
      --add-flags $out/lib/node_modules/antares/main.js
    runHook postInstall
  '';

  dontNpmBuild = true;
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  meta = with lib; {
    description = "Modern, fast and productivity driven SQL client with a focus in UX";
    homepage = "https://github.com/antares-sql/antares";
    license = licenses.mit;
    maintainers = with maintainers; [ eymeric ];
  };
}
