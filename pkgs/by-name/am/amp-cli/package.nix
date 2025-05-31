{
  lib,
  buildNpmPackage,
  fetchzip,
  ripgrep,
  makeWrapper,
}:

buildNpmPackage rec {
  pname = "amp-cli";
  version = "0.0.1748404992-ga3f78f";

  src = fetchzip {
    url = "https://registry.npmjs.org/@sourcegraph/amp/-/amp-${version}.tgz";
    hash = "sha256-axd5VP7afa4ptAl/y8CEVguqoRKVRhWfRDSI0sgyXqA=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json

    # Create a minimal package.json with just the dependency we need (without devDependencies)
    cat > package.json <<EOF
    {
      "name": "amp-cli",
      "version": "0.0.0",
      "license": "UNLICENSED",
      "dependencies": {
        "@sourcegraph/amp": "${version}"
      },
      "bin": {
        "amp": "./bin/amp-wrapper.js"
      }
    }
    EOF

    # Create wrapper bin directory
    mkdir -p bin

    # Create a wrapper script that will be installed by npm
    cat > bin/amp-wrapper.js << EOF
    #!/usr/bin/env node
    require('@sourcegraph/amp/dist/amp.js')
    EOF
    chmod +x bin/amp-wrapper.js
  '';

  npmDepsHash = "sha256-05+hBr+eX3I92U9TsqPQrYcJCmKXTvz3n6ZTxR1XvC8=";

  propagatedBuildInputs = [
    ripgrep
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  npmFlags = [
    "--no-audit"
    "--no-fund"
    "--ignore-scripts"
  ];

  # Disable build and prune steps
  dontNpmBuild = true;

  postInstall = ''
    wrapProgram $out/bin/amp \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]}
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "CLI for Amp, an agentic coding agent in research preview from Sourcegraph";
    homepage = "https://ampcode.com/";
    downloadPage = "https://www.npmjs.com/package/@sourcegraph/amp";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      keegancsmith
      owickstrom
    ];
    mainProgram = "amp";
  };
}
