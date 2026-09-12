{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
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
}:

buildNpmPackage (finalAttrs: {
  pname = "aurral";
  version = "2.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lklynet";
    repo = "aurral";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ceo5CHIGa+98XFLazqmAyAV64rzDYqB0gvJ95AKwfUk=";
  };

  # Specifies files to package leveraging npm & nix hooks. Not used by upstream.
  # Remove engine constraint not matching upstream dockerfile.
  patches = [
    ./package.json.patch
  ];

  npmDepsHash = "sha256-Qa/TcKzMEY/w8FWKMiHUeqVB9cMxxWtEwF30y0nndkg=";

  nodejs = nodejs_26;

  env.VITE_APP_VERSION = finalAttrs.version;

  npmInstallFlags = [
    "--include=optional"
    "--include-workspace-root=false"
  ];

  npmBuildFlags = [ "--workspace=frontend" ];

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
    export FONTCONFIG_FILE=${
      makeFontsConf {
        fontDirectories = [
          noto-fonts-color-emoji
          dejavu_fonts
        ];
      }
    }
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

  passthru.updateScript = nix-update-script { };

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
