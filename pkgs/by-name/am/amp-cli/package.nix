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
  version = "0.0.1754036264-ga0aa13";

  src = fetchzip {
    url = "https://registry.npmjs.org/@sourcegraph/amp/-/amp-${finalAttrs.version}.tgz";
    hash = "sha256-+pvxRLoluRk6/XfPr5luW2oIAjWTCYMJo53wHzQh598=";
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
    import('@sourcegraph/amp/dist/main.js')
    EOF
    chmod +x bin/amp-wrapper.js
  '';

  npmDepsHash = "sha256-Xm/uZAf9bDasHGIhcS2G8JUo3GyTdnErjzU7clkFQW0=";

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
