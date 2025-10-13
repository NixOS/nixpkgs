{
  lib,
  buildNpmPackage,
  bruno,
  pkg-config,
  pango,
  testers,
  bruno-cli,
}:

let
  pname = "bruno-cli";
in
buildNpmPackage {
  inherit pname;

  # since they only make releases and git tags for bruno,
  # we lie about bruno-cli's version and say it's the same as bruno's
  # to keep them in sync with easier maintenance
  inherit (bruno) version src npmDepsHash;

  npmWorkspace = "packages/bruno-cli";
  npmFlags = [ "--legacy-peer-deps" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    pango
  ];

  postConfigure = ''
    # sh: line 1: /build/source/packages/bruno-converters/node_modules/.bin/rimraf: cannot execute: required file not found
    patchShebangs packages/*/node_modules
  '';

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  buildPhase = ''
    runHook preBuild

    npm run build --workspace=packages/bruno-common
    npm run build --workspace=packages/bruno-graphql-docs
    npm run build --workspace=packages/bruno-converters
    npm run build --workspace=packages/bruno-query
    npm run build --workspace=packages/bruno-filestore
    npm run build --workspace=packages/bruno-requests

    npm run sandbox:bundle-libraries --workspace=packages/bruno-js

    runHook postBuild
  '';

  npmPackFlags = [ "--ignore-scripts" ];

  postInstall = ''
    cp -r packages $out/lib/node_modules/usebruno

    echo "Removing unnecessary files"
    pushd $out/lib/node_modules/usebruno

    # packages used by the GUI app, unused by CLI
    rm -r packages/bruno-{app,electron,tests,toml,schema,docs}
    rm node_modules/bruno
    rm node_modules/@usebruno/{app,tests,toml,schema}

    # heavy dependencies that seem to be unused
    rm -rf node_modules/{@tabler,pdfjs-dist,*redux*,prettier,@types*,*react*,*graphiql*}
    rm -r node_modules/.bin

    # unused file types
    for pattern in '*.map' '*.map.js' '*.ts'; do
      find . -type f -name "$pattern" -exec rm {} +
    done

    popd
    echo "Removed unnecessary files"
  '';

  postFixup = ''
    wrapProgram $out/bin/bru \
      --prefix NODE_PATH : $out/lib/node_modules/usebruno/packages/bruno-cli/node_modules \
      --prefix NODE_PATH : $out/lib/node_modules
  '';

  passthru.tests.help = testers.runCommand {
    name = "${pname}-help-test";
    nativeBuildInputs = [ bruno-cli ];
    script = ''
      bru --help && touch $out
    '';
  };

  meta = {
    description = "CLI of the open-source IDE For exploring and testing APIs";
    homepage = "https://www.usebruno.com";
    license = lib.licenses.mit;
    mainProgram = "bru";
    maintainers = with lib.maintainers; [
      gepbird
      kashw2
      lucasew
      mattpolzin
      water-sucks
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
