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

  # Compile it since it uses Typescript
  buildPhase = ''
    runHook preBuild
    npm run compile
    find -name "*.ts" | xargs rm -f
    mkdir -p $out/lib/node_modules/antares
    cp -r dist/* $out/lib/node_modules/antares
    runHook postBuild
  '';

  postInstall = ''
    makeWrapper ${electron}/bin/electron $out/bin/antares \
      --add-flags $out/lib/node_modules/antares/main.js
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
