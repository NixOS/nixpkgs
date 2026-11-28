{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
  autoPatchelfHook,
  makeWrapper,
  nodejs_24,
  nix-update-script,
  nixosTests,
  runCommand,
  jq,
}:

buildNpmPackage (finalAttrs: {
  pname = "openchronology-server";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "openchronology";
    repo = "timeline-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FKYfisHCZh8EGdRalwJ1kT2ma0g09VJCM7kr0IBPqCQ=";
  };

  nodejs = nodejs_24;
  npmDepsHash = "sha256-eZMBaLibGpqIb2IHlQLoczI3gWEgphDI4ChdtBUbm44=";
  # Install scripts would download browsers (Playwright) and binaries that the lockfile's
  # optional packages already provide.
  npmFlags = [ "--ignore-scripts" ];
  # npm adds the vendored rational-ordered-map tarball (a file: dependency) to its cache.
  makeCacheWritable = true;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];
  # The prebuilt native modules npm installs (sharp and its libvips, which Next.js uses for
  # images) link the C++ runtime.
  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  env = {
    NEXT_TELEMETRY_DISABLED = "1";
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    # Shown in the site's footer; the source has no .git to read it from.
    OCH_BUILD_VERSION = "v${finalAttrs.version}";
  };

  buildPhase = ''
    runHook preBuild
    npm run build
    # The corresponding source with the converter's crates, which the site's footer offers.
    cp -rL --no-preserve=mode ${finalAttrs.passthru.och-convert.cargoDeps} rust-dependencies
    node scripts/source.mjs --rust-vendor rust-dependencies
    cp dist/openchronology-web-source.tar.gz platform/public/
    runHook postBuild
  '';

  # Laid out as upstream's Debian package installs it, with commands in bin.
  installPhase = ''
    runHook preInstall
    app=$out/lib/openchronology
    mkdir -p $app/platform/.next $app/bin $out/bin
    cp -r platform/.next/standalone/. $app/
    cp -r platform/.next/static $app/platform/.next/static
    rm -rf $app/platform/public
    cp -r platform/public $app/platform/public
    cp -r dist server legal package.json $app/
    cp deploy/debian-server/openchronology-server.mjs $app/
    ln -s ${lib.getExe finalAttrs.passthru.och-convert} $app/bin/och-convert

    # The server reads OCH_CONFIG, an environment file, when one is given.
    makeWrapper ${lib.getExe nodejs_24} $out/bin/openchronology-server \
      --add-flags $app/openchronology-server.mjs --chdir $app \
      --set-default OCH_CONFIG /dev/null
    for command in migrate:migrate reset-admin-password:reset-admin-password \
        mail:mail-worker syslog:syslog-receiver github:github-receiver journald:journald-receiver; do
      makeWrapper ${lib.getExe nodejs_24} $out/bin/openchronology-''${command%%:*} \
        --add-flags $app/server/''${command#*:}.mjs --chdir $app --set NODE_ENV production
    done
    makeWrapper ${lib.getExe nodejs_24} $out/bin/och-import-logs \
      --add-flags $app/server/import-logs.mjs
    makeWrapper ${lib.getExe nodejs_24} $out/bin/och-import-github \
      --add-flags $app/server/import-github.mjs
    runHook postInstall
  '';

  passthru = {
    och-convert = callPackage ./och-convert.nix { inherit (finalAttrs) version src; };
    updateScript = nix-update-script { };
    tests = {
      nixos = nixosTests.openchronology;
      # A timeline written as an .och file (SQLite) and read back, its exact time intact.
      och-convert =
        runCommand "och-convert-round-trip"
          {
            nativeBuildInputs = [
              finalAttrs.passthru.och-convert
              jq
            ];
          }
          ''
            echo '{"format":"openchronology","version":1,"title":"Round trip","description":"","events":[{"id":"a","time":"1/3","metadata":{"title":"A third"}}]}' \
              | och-convert write timeline.och
            och-convert read timeline.och > back.json
            jq -e '.title == "Round trip" and .events[0].time == "1/3" and .events[0].metadata.title == "A third"' back.json
            touch $out
          '';
    };
  };

  meta = {
    description = "Web server for OpenChronology, an editor and platform for exact timelines";
    longDescription = ''
      OpenChronology stores timelines with exact, arbitrary-precision times. The server runs
      the editor and the publishing platform; it needs PostgreSQL with the pgmp extension
      (postgresqlPackages.pgmp).
    '';
    homepage = "https://github.com/openchronology/timeline-app";
    changelog = "https://github.com/openchronology/timeline-app/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ athanclark ];
    mainProgram = "openchronology-server";
    platforms = lib.platforms.linux;
  };
})
