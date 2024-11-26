{
  lib,
  stdenv,
  nodejs-slim,
  bundlerEnv,
  nixosTests,
  yarn-berry,
  callPackage,
  ruby,
  writeShellScript,
  brotli,
  python3,

  # Allow building a fork or custom version of Mastodon:
  pname ? "mastodon",
  version ? srcOverride.version,
  patches ? [ ],
  # src is a package
  srcOverride ? callPackage ./source.nix { inherit patches; },
  gemset ? ./. + "/gemset.nix",
  yarnHash ? srcOverride.yarnHash,
}:

stdenv.mkDerivation rec {
  inherit pname version;

  src = srcOverride;

  mastodonGems = bundlerEnv {
    name = "${pname}-gems-${version}";
    inherit version gemset ruby;
    gemdir = src;
  };

  mastodonModules = stdenv.mkDerivation {
    pname = "${pname}-modules";
    inherit src version;

    yarnOfflineCache = callPackage ./yarn.nix {
      inherit version src;
      hash = yarnHash;
    };

    nativeBuildInputs = [
      nodejs-slim
      yarn-berry
      mastodonGems
      mastodonGems.wrappedRuby
      brotli
      python3
    ];

    RAILS_ENV = "production";
    NODE_ENV = "production";

    buildPhase = ''
      runHook preBuild

      export HOME=$PWD
      export YARN_ENABLE_TELEMETRY=0
      export npm_config_nodedir=${nodejs-slim}
      export SECRET_KEY_BASE_DUMMY=1

      mkdir -p ~/.yarn/berry
      ln -s $yarnOfflineCache ~/.yarn/berry/cache

      yarn install --immutable --immutable-cache

      patchShebangs ~/bin
      patchShebangs ~/node_modules

      bundle exec rails assets:precompile

      yarn cache clean --all
      rm -rf ~/node_modules/.cache

      # Remove execute permissions
      find ~/public/assets -type f ! -perm 0555 \
        -exec chmod 0444 {} ';'

      # Create missing static gzip and brotli files
      find ~/public/assets -type f -regextype posix-extended -iregex '.*\.(css|html|js|json|svg)' \
        -exec gzip --best --keep --force {} ';' \
        -exec brotli --best --keep {} ';'
      gzip --best --keep ~/public/packs/report.html
      brotli --best --keep ~/public/packs/report.html

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/public
      cp -r node_modules $out/node_modules
      cp -r public/assets $out/public
      cp -r public/packs $out/public

      runHook postInstall
    '';
  };

  propagatedBuildInputs = [ mastodonGems.wrappedRuby ];
  nativeBuildInputs = [ brotli ];
  buildInputs = [
    mastodonGems
    nodejs-slim
  ];

  buildPhase = ''
    runHook preBuild

    ln -s $mastodonModules/node_modules node_modules
    ln -s $mastodonModules/public/assets public/assets
    ln -s $mastodonModules/public/packs public/packs

    patchShebangs bin/
    for b in $(ls $mastodonGems/bin/)
    do
      if [ ! -f bin/$b ]; then
        ln -s $mastodonGems/bin/$b bin/$b
      fi
    done

    # Remove execute permissions
    find public/emoji -type f ! -perm 0555 \
      -exec chmod 0444 {} ';'

    # Create missing static gzip and brotli files
    find public -maxdepth 1 -type f -regextype posix-extended -iregex '.*\.(js|txt)' \
      -exec gzip --best --keep --force {} ';' \
      -exec brotli --best --keep {} ';'
    find public/emoji -type f -name '*.svg' \
      -exec gzip --best --keep --force {} ';' \
      -exec brotli --best --keep {} ';'
    ln -s assets/500.html.gz public/500.html.gz
    ln -s assets/500.html.br public/500.html.br
    ln -s packs/sw.js.gz public/sw.js.gz
    ln -s packs/sw.js.br public/sw.js.br
    ln -s packs/sw.js.map.gz public/sw.js.map.gz
    ln -s packs/sw.js.map.br public/sw.js.map.br

    rm -rf log
    ln -s /var/log/mastodon log
    ln -s /tmp tmp

    runHook postBuild
  '';

  installPhase =
    let
      run-streaming = writeShellScript "run-streaming.sh" ''
        # NixOS helper script to consistently use the same NodeJS version the package was built with.
        ${nodejs-slim}/bin/node ./streaming
      '';
    in
    ''
      runHook preInstall

      mkdir -p $out
      mv .{env*,ruby*} $out/
      mv * $out/
      ln -s ${run-streaming} $out/run-streaming.sh

      runHook postInstall
    '';

  passthru = {
    tests.mastodon = nixosTests.mastodon;
    # run with: nix-shell ./maintainers/scripts/update.nix --argstr package mastodon
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Self-hosted, globally interconnected microblogging software based on ActivityPub";
    homepage = "https://joinmastodon.org";
    license = licenses.agpl3Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [
      happy-river
      erictapen
      izorkin
      ghuntley
    ];
  };
}
