{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage rec {
  pname = "amp-cli";
  version = "0.0.1746576109-gdbe42c";

  src = fetchzip {
    url = "https://registry.npmjs.org/@sourcegraph/amp/-/amp-${version}.tgz";
    hash = "sha256-nvKz1JKKwwmZIEYmYFz5eo6oMlUOeW2riNjjJKvNs1A=";
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

  npmDepsHash = "sha256-IQl/LykkKeZ0/cCzviaZIFdNXx8q59uLdQrbPmERQYo=";

  npmFlags = [
    "--no-audit"
    "--no-fund"
    "--ignore-scripts"
  ];

  # Disable build and prune steps
  dontNpmBuild = true;
  dontNpmPrune = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Amp is an AI coding agent, in research preview from Sourcegraph. This is the CLI for Amp.";
    homepage = "https://github.com/sourcegraph/amp";
    downloadPage = "https://www.npmjs.com/package/@sourcegraph/amp";
    license = lib.licenses.unfree;
    maintainers = [
      # Add maintainer(s) here, e.g., lib.maintainers.your_github_username
    ];
    mainProgram = "amp";
  };
}
