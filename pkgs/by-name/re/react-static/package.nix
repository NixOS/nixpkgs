{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
}:

mkYarnPackage rec {
  pname = "react-static";
  version = "7.6.2";

  src = fetchFromGitHub {
    owner = "react-static";
    repo = "react-static";
    rev = "v${version}";
    hash = "sha256-dlYmD0vgEqWxYf7E0VYstZMAuNDGvQP7xDgHo/wmlUs=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-SNnJPUzv+l2HXfA6NKYpJvn/DCX3a42JQ3N0+XYKbd8=";
  };

  buildPhase = ''
    runHook preBuild

    yarn --cwd deps/react-static/packages/react-static --offline build

    runHook postBuild
  '';

  doDist = false;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/node_modules"
    mv deps/react-static/packages/react-static "$out/lib/node_modules"
    mv node_modules "$out/lib/node_modules/react-static"

    ln -s "$out/lib/node_modules/react-static/bin" "$out"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/react-static/react-static/blob/${src.rev}/CHANGELOG.md";
    description = "Progressive static site generator for React";
    homepage = "https://github.com/react-static/react-static";
    license = lib.licenses.mit;
    mainProgram = "react-static";
    maintainers = [ ];
  };
}
