{
  lib,
  buildGoModule,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
  npm-lockfile-fix,
  fetchNpmDeps,
  jq,
  nixosTests,

  versionInfo ? {
    # ESR releases only.
    # See https://docs.mattermost.com/upgrade/extended-support-release.html
    # When a new ESR version is available (e.g. 8.1.x -> 9.5.x), update
    # the version regex here as well.
    #
    # Ensure you also check ../mattermostLatest/package.nix.
    regex = "^v(9\\.11\\.[0-9]+)$";
    version = "9.11.9";
    srcHash = "sha256-sEu5s+yMCPYxvyc7kuiA9AE/qBi08iTqhYxwO7J9xiE=";
    vendorHash = "sha256-h/hcdVImU3wFp7BGHS/TxYBEWGv9v06y8etaz9OrHTA=";
    npmDepsHash = "sha256-B7pXMHwyf7dQ2x2VJu+mdZz03/9FyyYvFYOw8XguTH8=";
  },
}:

buildGoModule rec {
  pname = "mattermost";
  inherit (versionInfo) version;

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost";
    tag = "v${version}";
    hash = versionInfo.srcHash;
    postFetch = ''
      cd $out/webapp

      # Remove "+..." suffixes on versions.
      ${lib.getExe jq} '
        def desuffix(version): version | gsub("^(?<prefix>[^\\+]+)\\+.*$"; "\(.prefix)");
        .packages |= map_values(if has("version") then .version = desuffix(.version) else . end)
      ' < package-lock.json > package-lock.fixed.json

      # Run the lockfile overlay, if present.
      ${lib.optionalString (versionInfo.lockfileOverlay or null != null) ''
        ${lib.getExe jq} ${lib.escapeShellArg ''
          # Unlock a dependency and let npm-lockfile-fix relock it.
          def unlock(root; dependency; path):
            root | .packages[path] |= del(.resolved, .integrity)
                 | .packages[path].version = root.packages.channels.dependencies[dependency];
          ${versionInfo.lockfileOverlay}
        ''} < package-lock.fixed.json > package-lock.overlaid.json
        mv package-lock.overlaid.json package-lock.fixed.json
      ''}
      ${lib.getExe npm-lockfile-fix} package-lock.fixed.json

      rm -f package-lock.json
      mv package-lock.fixed.json package-lock.json
    '';
  };

  # Needed because buildGoModule does not support go workspaces yet.
  # We use go 1.22's workspace vendor command, which is not yet available
  # in the default version of go used in nixpkgs, nor is it used by upstream:
  # https://github.com/mattermost/mattermost/issues/26221#issuecomment-1945351597
  overrideModAttrs = (
    _: {
      buildPhase = ''
        make setup-go-work
        go work vendor -e
      '';
    }
  );

  npmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/webapp";
    hash = versionInfo.npmDepsHash;
    makeCacheWritable = true;
    forceGitDeps = true;
  };

  webapp = buildNpmPackage rec {
    pname = "mattermost-webapp";
    inherit version src;

    sourceRoot = "${src.name}/webapp";

    # Remove deprecated image-webpack-loader causing build failures
    # See: https://github.com/tcoopman/image-webpack-loader#deprecated
    postPatch = ''
      substituteInPlace channels/webpack.config.js \
        --replace-fail 'options: {}' 'options: { disable: true }'
    '';

    npmDepsHash = npmDeps.hash;
    makeCacheWritable = true;
    forceGitDeps = true;

    npmRebuildFlags = [ "--ignore-scripts" ];

    buildPhase = ''
      runHook preBuild

      npm run build --workspace=platform/types
      npm run build --workspace=platform/client
      npm run build --workspace=platform/components
      npm run build --workspace=channels

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -a channels/dist/* $out

      runHook postInstall
    '';
  };

  inherit (versionInfo) vendorHash;

  modRoot = "./server";
  preBuild = ''
    make setup-go-work
  '';

  subPackages = [ "cmd/mattermost" ];

  tags = [ "production" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mattermost/mattermost/server/public/model.Version=${version}"
    "-X github.com/mattermost/mattermost/server/public/model.BuildNumber=${version}-nixpkgs"
    "-X github.com/mattermost/mattermost/server/public/model.BuildDate=1970-01-01"
    "-X github.com/mattermost/mattermost/server/public/model.BuildHash=v${version}"
    "-X github.com/mattermost/mattermost/server/public/model.BuildHashEnterprise=none"
    "-X github.com/mattermost/mattermost/server/public/model.BuildEnterpriseReady=false"
  ];

  postInstall = ''
    shopt -s extglob
    mkdir -p $out/{i18n,fonts,templates,config}

    # Link in the client and copy the language packs.
    ln -sf $webapp $out/client
    cp -a $src/server/i18n/* $out/i18n/

    # Fonts have the execute bit set, remove it.
    cp --no-preserve=mode $src/server/fonts/* $out/fonts/

    # Don't copy the Makefile.
    cp -a $src/server/templates/!(Makefile) $out/templates/

    # Generate the config.
    OUTPUT_CONFIG=$out/config/config.json \
      go run -tags production ./scripts/config_generator
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs =
        [
          "--version-regex"
          versionInfo.regex
        ]
        ++ lib.optionals (versionInfo.autoUpdate or null != null) [
          "--override-filename"
          versionInfo.autoUpdate
        ];
    };
    tests.mattermost = nixosTests.mattermost;
  };

  meta = with lib; {
    description = "Mattermost is an open source platform for secure collaboration across the entire software development lifecycle";
    homepage = "https://www.mattermost.org";
    license = with licenses; [
      agpl3Only
      asl20
    ];
    maintainers = with maintainers; [
      ryantm
      numinit
      kranzes
      mgdelacroix
      fsagbuya
    ];
    mainProgram = "mattermost";
  };
}
