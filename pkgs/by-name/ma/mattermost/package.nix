{
  lib,
  buildGoModule,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
  npm-lockfile-fix,
  fetchNpmDeps,
  diffutils,
  jq,
  nixosTests,
}:

buildGoModule rec {
  pname = "mattermost";
  # ESR releases only.
  # See https://docs.mattermost.com/upgrade/extended-support-release.html
  # When a new ESR version is available (e.g. 8.1.x -> 9.5.x), update
  # the version regex in passthru.updateScript as well.
  version = "9.11.6";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost";
    rev = "v${version}";
    hash = "sha256-G9RYktnnVXdhNWp8q+bNbdlHB9ZOGtnESnZVOA7lDvE=";
    postFetch = ''
      cd $out/webapp

      # Remove "+..." suffixes on versions.
      ${lib.getExe jq} '
        def desuffix(version): version | gsub("^(?<prefix>[^\\+]+)\\+.*$"; "\(.prefix)");
        .packages |= map_values(if has("version") then .version = desuffix(.version) else . end)
      ' < package-lock.json > package-lock.fixed.json
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
    hash = "sha256-ysz38ywGxJ5DXrrcDmcmezKbc5Y7aug9jOWUzHRAs/0=";
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
      cp -r channels/dist/* $out

      runHook postInstall
    '';
  };

  vendorHash = "sha256-Gwv6clnq7ihoFC8ox8iEM5xp/us9jWUrcmqA9/XbxBE=";

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
    mkdir -p $out/{client,i18n,fonts,templates,config}
    cp -r ${webapp}/* $out/client/
    cp -r ${src}/server/i18n/* $out/i18n/
    cp -r ${src}/server/fonts/* $out/fonts/
    cp -r ${src}/server/templates/* $out/templates/
    OUTPUT_CONFIG=$out/config/config.json \
      go run -tags production ./scripts/config_generator
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(9\.11\.[0-9]+)$"
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
