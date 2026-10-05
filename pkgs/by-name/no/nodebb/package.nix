{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  python3,
  dart-sass,
  vips,
  nodejs,
  makeBinaryWrapper,
  nix-update-script,
  nixosTests,
  callPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "nodebb";
  version = "4.15.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NodeBB";
    repo = "NodeBB";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UHSuQ/c9r4WrLtUSS63MqCHmWHxeixBdnIvm8BBqRjU=";
    # nix-update --generate-lockfile runs npm inside the fetched src, which
    # has no root package.json (upstream keeps it under install/).
    postFetch = ''
      cp $out/install/package.json $out/package.json
    '';
  };

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmDepsHash = "sha256-p6PhfuLBJFHl2cgXhqHjSuVQsFeNZNdmRK89tWwu1Os=";
  npmInstallFlags = [ "--omit=dev" ];
  makeCacheWritable = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    python3
  ];

  buildInputs = [ vips ];

  env = {
    npm_config_nodedir = nodejs;
    SHARP_FORCE_GLOBAL_LIBVIPS = "1";
  };

  # webpack runs at `nodebb setup`, not at install. There is no npm build script.
  dontNpmBuild = true;

  # postPatch is too early: sass-embedded is not installed yet.
  preBuild = ''
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'
  '';

  # NodeBB is an application, not an npm library. `npm pack` would follow
  # .gitignore and drop src/, public/, and the generated package.json.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/nodebb $out/bin
    cp -a . $out/lib/node_modules/nodebb

    makeBinaryWrapper ${lib.getExe nodejs} $out/bin/nodebb \
      --add-flags $out/lib/node_modules/nodebb/nodebb \
      --set-default NODE_ENV production \
      --chdir $out/lib/node_modules/nodebb

    runHook postInstall
  '';

  passthru = {
    inherit nodejs;
    plugins = callPackage ./plugins.nix { };
    withPackages = callPackage ./wrapper.nix { nodebb = finalAttrs.finalPackage; };
    defaultPlugins = [
      "nodebb-plugin-composer-default"
      "nodebb-plugin-dbsearch"
      "nodebb-plugin-markdown"
      "nodebb-plugin-mentions"
      "nodebb-plugin-web-push"
      "nodebb-widget-essentials"
      "nodebb-rewards-essentials"
      "nodebb-plugin-emoji"
      "nodebb-plugin-emoji-android"
      "nodebb-theme-harmony"
    ];
    tests = {
      inherit (nixosTests) nodebb;
    };
    updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };
  };

  meta = {
    description = "Node.js based forum software";
    longDescription = ''
      NodeBB is community forum software that uses websockets for live
      notifications and supports Redis, PostgreSQL, or MongoDB. Version 4
      federates over ActivityPub.
    '';
    homepage = "https://nodebb.org/";
    changelog = "https://github.com/NodeBB/NodeBB/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      lucasew
      prince213
    ];
    teams = with lib.teams; [ ngi ];
    platforms = lib.platforms.linux;
    mainProgram = "nodebb";
  };
})
