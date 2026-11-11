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
  version = "2.12.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "lklynet";
    repo = "aurral";
    tag = "v${finalAttrs.version}";
    hash = "sha256-slnwPhWqQDEbtkV+gTiSHHMvOxJ4de3kR85YVdP5pO0=";
  };

  # Test fixtures create executable scripts; /usr/bin/env is unavailable in the sandbox.
  postPatch = relaxNodeVersion + ''
    substituteInPlace .tests/share/share-links.test.ts \
      .tests/download/ytdlp-song-search.test.ts \
      .tests/download/ytdlp-runtime.test.ts \
      --replace-fail '#!/usr/bin/env node' '#!${lib.getExe nodejs_26}'
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    postPatch = relaxNodeVersion;
    fetcherVersion = 5;
    hash = "sha256-juz5YV5Vc0N24OfSjb7iltS+iLYEKUKVOML1mPS5s+0=";
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
    pnpm test
    pnpm run test:integration
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
        exec node $out/lib/aurral/backend/server.ts
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
