{
  lib,
  buildNpmPackage,
  fetchzip,
  ripgrep,
  makeWrapper,
  testers,
}:

buildNpmPackage (finalAttrs: {
  pname = "amp-cli";
  version = "0.0.1750147289-g2a47fe";

  src = fetchzip {
    url = "https://registry.npmjs.org/@sourcegraph/amp/-/amp-${finalAttrs.version}.tgz";
    hash = "sha256-mP4YOa2J4K3mr7PpRn+Nn+AMcmMSSTNcB59QEdAFZeE=";
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
        "@sourcegraph/amp": "${finalAttrs.version}"
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

  npmDepsHash = "sha256-aF4oMWmq4+tuXAhwDgqTX3dfHNV1upyD0dqBEoJiru8=";

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
  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "HOME=$(mktemp -d) amp --version";
  };

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
})
