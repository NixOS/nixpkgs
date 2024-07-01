{
  lib,
  mkYarnPackage,
  fetchYarnDeps,
  fetchFromGitHub,
  nix-update-script
}: mkYarnPackage rec {
  pname = "coc-css";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-css";
    rev = version;
    hash = "sha256-ASFg5LM1NbpK+Df1TPs+O13WmZktw+BtfsCJagF5nUc=";
  };

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-JJXpsccO9MZ0D15JUZtTebX1zUMgwGEzSOm7auw5pQo=";
  };

  buildPhase = ''
    runHook preBuild
    yarn --offline build
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/lib
    mv node_modules $out/lib/
    unlink $out/lib/node_modules/coc-css
    mv deps/coc-css $out/lib/node_modules/coc-css
  '';

  doDist = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Css language server extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-css";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
