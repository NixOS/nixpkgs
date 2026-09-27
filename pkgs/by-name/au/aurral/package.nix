{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
  nodejs_26,
  python3,
  sqlite,
  ffmpeg,
  yt-dlp,
  jemalloc,
  runtimeShell,
  makeFontsConf,
  noto-fonts-color-emoji,
  dejavu_fonts,
  nixosTests,
}:

let
  matcherPython = python3.withPackages (ps: [ ps.beets ]);
in
buildNpmPackage (finalAttrs: {
  pname = "aurral";
  version = "2.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lklynet";
    repo = "aurral";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PNTcFtP9ajEBi3X7oofdsm5K0bN9T4MlMYA0+srFqgs=";
  };

  # Specifies files to package leveraging npm & nix hooks. Not used by upstream.
  patches = [
    ./package.json.patch
  ];

  postPatch = ''
    substituteInPlace backend/services/trackMatching/beetsClient.js \
      --replace-fail 'const PINNED_BEETS_VERSION = "2.14.0";' \
      'const PINNED_BEETS_VERSION = "${python3.pkgs.beets.version}";'
    substituteInPlace .tests/track-matching/beets-client.test.js \
      --replace-fail 'assert.equal(status.error.required, "2.14.0");' \
      'assert.equal(status.error.required, "${python3.pkgs.beets.version}");'
    substituteInPlace .tests/honker/background-worker-recovery.test.js \
      --replace-fail '  assert.equal(registry?.inFlightActive, undefined);' \
      '  assert.equal(registry?.inFlightActive, undefined); queue.cancel(jobId);'
  '';

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-8GmWzjja+SYIkJa+VqkA0nmY10B/bjq7i2RR8qZBofo=";

  nodejs = nodejs_26;

  env.AURRAL_MATCHER_PYTHON = "${matcherPython}/bin/python";
  env.VITE_APP_VERSION = finalAttrs.version;
  env.LD_LIBRARY_PATH = lib.makeLibraryPath [ sqlite ];
  env.FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [
      noto-fonts-color-emoji
      dejavu_fonts
    ];
  };

  npmInstallFlags = [
    "--include=optional"
    "--include-workspace-root=false"
  ];

  npmBuildFlags = [ "--workspace=frontend" ];

  doCheck = true;

  nativeCheckInputs = [
    ffmpeg
    gitMinimal
  ];

  checkPhase = ''
    runHook preCheck

    npm test
    npm run test:integration

    runHook postCheck
  '';

  npmPruneFlags = [
    "--workspace=backend"
    "--include=optional"
    "--include-workspace-root=false"
  ];

  postInstall = ''
    mkdir $out/bin
    cat > $out/bin/aurral <<EOL
    #!${runtimeShell} -e
    export LD_PRELOAD=${lib.getLib jemalloc}/lib/libjemalloc.so
    export LD_LIBRARY_PATH=${
      lib.makeLibraryPath [
        sqlite
      ]
    }
    export PATH=${
      lib.makeBinPath [
        finalAttrs.nodejs
        ffmpeg
        yt-dlp
      ]
    }\''${PATH:+:}\$PATH
    export FONTCONFIG_FILE=${finalAttrs.env.FONTCONFIG_FILE}
    export AURRAL_MATCHER_PYTHON=${matcherPython}/bin/python
    export APP_VERSION=${finalAttrs.version}
    export NODE_ENV=production
    case "\$1" in
        resetAdminPassword)
        exec node $out/lib/node_modules/aurral/backend/scripts/resetAdminPassword.js "\$@"
        ;;
        server|"")
        exec node $out/lib/node_modules/aurral/backend/server.js
        ;;
        -h|--help|*)
        echo "Usage: (server|resetAdminPassword)"
        echo
        echo "We recommend using it in the service namespace. Example:"
        echo "sudo nsenter -t \\\$(systemctl show --property MainPID --value aurral.service) -a -e -S follow -G follow aurral resetAdminPassword -g"
        ;;
    esac
    EOL
    chmod +x $out/bin/aurral
  '';

  passthru = {
    tests = nixosTests.aurral;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Aurral is the Lidarr companion for self-hosted music discovery";
    mainProgram = "aurral";
    homepage = "https://aurral.org";
    changelog = "https://github.com/lklynet/aurral/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.intersectLists lib.platforms.linux (lib.platforms.x86_64 ++ lib.platforms.aarch64);
    maintainers = with lib.maintainers; [
      hougo
      staticdev
    ];
  };
})
