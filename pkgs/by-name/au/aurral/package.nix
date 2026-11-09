{
  lib,
  stdenv,
  fetchPnpmDeps,
  pnpm_12,
  pnpmConfigHook,
  cloudflared,
  procps,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
  nodejs_26,
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
  pnpm = pnpm_12.override { nodejs-slim = nodejs_26; };
  # Upstream pins a Node minor release, but Nixpkgs tracks the latest Node 26.
  relaxNodeVersion = ''
    substituteInPlace package.json \
      --replace-fail '"node": "26.12.x"' '"node": "26.x"'
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "aurral";
  version = "2.13.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "lklynet";
    repo = "aurral";
    tag = "v${finalAttrs.version}";
    hash = "sha256-covP+bdzYNxAo+DFL2Ck2A3XCltsHz431PFdrs2cWO0=";
  };

  postPatch = relaxNodeVersion;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    postPatch = relaxNodeVersion;
    fetcherVersion = 5;
    hash = "sha256-WdhVTDDuuwCjC6izOWb6g0bmIR8RNKHvlw8bK1NoZEE=";
  };

  nativeBuildInputs = [
    nodejs_26
    pnpm
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild
    pnpm rebuild
    pnpm --filter aurral-frontend run build
    runHook postBuild
  '';

  env.VITE_APP_VERSION = finalAttrs.version;
  env.LD_LIBRARY_PATH = lib.makeLibraryPath [ sqlite ];
  env.FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [
      noto-fonts-color-emoji
      dejavu_fonts
    ];
  };

  doCheck = true;
  nativeCheckInputs = [
    ffmpeg
    gitMinimal
    procps
  ];
  checkPhase = ''
    runHook preCheck
    # Test forks start background workers, so bound their concurrency as well.
    testWorkers=$((NIX_BUILD_CORES < 2 ? NIX_BUILD_CORES : 2))
    pnpm test --maxWorkers="$testWorkers"
    pnpm run test:integration --maxWorkers="$testWorkers"
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    # pnpm prune does not support this workspace with the packaged pnpm version.
    # Reinstall only the root and backend production dependencies from the offline store.
    rm -rf node_modules backend/node_modules frontend/node_modules docs/node_modules
    pnpm install --offline --ignore-scripts --frozen-lockfile --prod \
      --filter=aurral --filter=aurral-backend

    mkdir -p $out/lib/aurral/frontend
    cp -r package.json backend lib node_modules $out/lib/aurral/
    cp -r frontend/dist $out/lib/aurral/frontend/
    runHook postInstall
  '';

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
        nodejs_26
        ffmpeg
        yt-dlp
        cloudflared
      ]
    }\''${PATH:+:}\$PATH
    export FONTCONFIG_FILE=${finalAttrs.env.FONTCONFIG_FILE}
    export APP_VERSION=${finalAttrs.version}
    export NODE_ENV=production
    case "\$1" in
        resetAdminPassword)
        exec node $out/lib/aurral/backend/scripts/resetAdminPassword.ts "\$@"
        ;;
        server|"")
        exec node --max-semi-space-size=4 $out/lib/aurral/backend/server.ts
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
