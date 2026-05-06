{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,

  # build
  brotli,
  dart-sass,
  fd,
  jq,
  pnpmConfigHook,
  pnpm_10,
  which,

  # runtime
  nodejs_20,

  # tests
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "peertube";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "Chocobozzz";
    repo = "PeerTube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u4LDk9r88h3EqX6ZRMPCQmjOvfJDXwV2YYrKEkGBWgs=";
  };

  outputs = [
    "out"
    "cli"
    "runner"
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-1CmfcDZ23oITP8GQGIBeZP4Z5AON0f3CtdHGnpZxHgQ=";
  };

  nativeBuildInputs = [
    brotli
    fd
    jq
    pnpmConfigHook
    pnpm_10
    which
  ];

  buildInputs = [
    nodejs_20
  ];

  preBuild = ''
    # force sass-embedded to use our own sass instead of the bundled one
    for dep in node_modules/.pnpm/sass-embedded@*; do
      substituteInPlace $dep/node_modules/sass-embedded/dist/lib/src/compiler-path.js \
          --replace-fail \
            'compilerCommand = (() => {' \
            'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'
    done
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$PWD

    # Build PeerTube server
    npm run build:server

    # Build PeerTube client
    npm run build:client

    # Build PeerTube cli
    npm run build:peertube-cli
    patchShebangs ~/apps/peertube-cli/dist/peertube.js

    # Build PeerTube runner
    npm run build:peertube-runner
    patchShebangs ~/apps/peertube-runner/dist/peertube-runner.js

    # Clean up declaration files
    find \
      ~/dist/ \
      ~/packages/core-utils/dist/ \
      ~/packages/ffmpeg/dist/ \
      ~/packages/models/dist/ \
      ~/packages/node-utils/dist/ \
      ~/packages/server-commands/dist/ \
      ~/packages/transcription/dist/ \
      ~/packages/typescript-utils/dist/ \
      \( -name '*.d.ts' -o -name '*.d.ts.map' \) -type f -delete

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/dist
    mv ~/dist $out
    mv ~/node_modules $out/node_modules

    mkdir $out/client
    mv ~/client/{dist,node_modules,package.json} $out/client

    mkdir -p $out/packages/{core-utils,ffmpeg,models,node-utils,server-commands,transcription,typescript-utils}
    mv ~/packages/core-utils/{dist,package.json} $out/packages/core-utils
    mv ~/packages/ffmpeg/{dist,package.json} $out/packages/ffmpeg
    mv ~/packages/models/{dist,package.json} $out/packages/models
    mv ~/packages/node-utils/{dist,package.json} $out/packages/node-utils
    mv ~/packages/server-commands/{dist,package.json} $out/packages/server-commands
    mv ~/packages/transcription/{dist,package.json} $out/packages/transcription
    mv ~/packages/typescript-utils/{dist,package.json} $out/packages/typescript-utils
    mv ~/{config,support,CREDITS.md,FAQ.md,LICENSE,README.md,package.json,pnpm-lock.yaml} $out

    # Remove broken symlinks in node_modules from workspace packages that aren't needed
    # by the built artifact. If any new packages break the check for broken symlinks,
    # they should be checked before adding them here to make sure they aren't likely to
    # be needed, either now or in the future. If they might be, then we probably want
    # to move the package to $out above instead of removing the broken symlink.
    rm $out/node_modules/.pnpm/node_modules/@peertube/{peertube-cli,peertube-runner,peertube-server,peertube-transcription-devtools,peertube-types-generator,tests,player}
    rm $out/client/node_modules/@peertube/player

    mkdir -p $cli/bin
    mv ~/apps/peertube-cli/{dist,node_modules,package.json} $cli
    ln -s $cli/dist/peertube.js $cli/bin/peertube-cli

    mkdir -p $runner/bin
    mv ~/apps/peertube-runner/{dist,node_modules,package.json} $runner
    ln -s $runner/dist/peertube-runner.js $runner/bin/peertube-runner

    # Create static gzip and brotli files
    fd -e css -e eot -e html -e js -e json -e svg -e webmanifest -e xlf \
      --type file --search-path $out/client/dist --threads $NIX_BUILD_CORES \
      --exec gzip -9 -n -c {} > {}.gz \;\
      --exec brotli --best -f {} -o {}.br

    runHook postInstall
  '';

  passthru.tests.peertube = nixosTests.peertube;

  meta = {
    description = "Free software to take back control of your videos";
    longDescription = ''
      PeerTube aspires to be a decentralized and free/libre alternative to video
      broadcasting services.
      PeerTube is not meant to become a huge platform that would centralize
      videos from all around the world. Rather, it is a network of
      inter-connected small videos hosters.
      Anyone with a modicum of technical skills can host a PeerTube server, aka
      an instance. Each instance hosts its users and their videos. In this way,
      every instance is created, moderated and maintained independently by
      various administrators.
      You can still watch from your account videos hosted by other instances
      though if the administrator of your instance had previously connected it
      with other instances.
    '';
    license = lib.licenses.agpl3Plus;
    homepage = "https://joinpeertube.org/";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      # feasible, looking for maintainer to help out
      # "x86_64-darwin" "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      immae
      izorkin
      stevenroose
    ];
    teams = with lib.teams; [
      ngi
    ];
  };
})
