{
  lib,
  applyPatches,
  bundlerEnv,
  fetchFromGitHub,
  fetchNpmDeps,
  h3_3,
  nixosTests,
  nodejs,
  npmHooks,
  ruby_3_4,
  stdenv,
  tailwindcss_3,

  sources ? ./. + "/sources.json",
  gemset ? import (./. + "/gemset.nix"),
}:
let
  ruby = ruby_3_4;
  sources' = lib.importJSON sources;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dawarich";
  inherit (sources') version;

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "Freika";
      repo = "dawarich";
      tag = finalAttrs.version;
      inherit (sources') hash;

    };
    patches = [
      # bundix and bundlerEnv fail with system-specific gems
      ./0001-build-ffi-gem.diff
      # openssl 3.6.0 breaks ruby openssl gem
      # See https://github.com/NixOS/nixpkgs/issues/456753
      # and https://github.com/ruby/openssl/issues/949#issuecomment-3370358680
      ./0002-openssl-hotfix.diff
    ];
    postPatch = ''
      substituteInPlace ./Gemfile \
        --replace-fail "ruby File.read('.ruby-version').strip" "ruby '>= 3.4.0'"
    '';
  };

  patches = [
    # Upstream is appending `/{number}` to REDIS_URL, but this does not work for unix socket URIs.
    # See https://github.com/redis-rb/redis-client/blob/98a51a42c9952f76238da7f6390315e7d1edb6b3/lib/redis_client/url_config.rb#L30-L42
    # Change the code to use the `db` parameter of the constructor instead, which should work for all URIs.
    # See https://github.com/redis-rb/redis-client/blob/98a51a42c9952f76238da7f6390315e7d1edb6b3/lib/redis_client/config.rb#L198-L201
    # Upstream issue: https://github.com/Freika/dawarich/issues/1507
    ./0003-redis-url-database.diff
    # See https://github.com/Freika/dawarich/issues/1909
    # and https://github.com/Freika/dawarich/pull/1910
    ./0004-fix-unmatched-end-utm-trackable.diff
  ];

  postPatch = ''
    # move import directory to a more convenient place, otherwise its behind systemd private tmp
    substituteInPlace ./app/services/imports/watcher.rb \
      --replace-fail 'tmp/imports/watched' 'storage/imports/watched'
  '';

  dawarichGems =
    let
      gemset' = gemset // {
        # This gem attempts to build h3 using cmake, but fails because that is not in the path
        # Use h3 from nixpkgs instead, and reduce closure size by deleting the h3 source code
        h3 = gemset.h3 // {
          dontBuild = false; # allow applying patches
          postPatch = ''
            substituteInPlace ext/h3/Makefile \
              --replace-fail 'cd src; cmake . -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DBUILD_SHARED_LIBS=true -DBUILD_FILTERS=OFF -DBUILD_BENCHMARKS=OFF -DENABLE_LINTING=OFF; make' ':'
            substituteInPlace lib/h3/bindings/base.rb \
              --replace-fail '__dir__ + "/../../../ext/h3/src/lib"' '"${h3_3}/lib"'
          '';
          postInstall = ''
            rm -rf $out/${ruby.gemPath}/gems/h3-${gemset.h3.version}/ext/h3/src
          '';
        };
      };
    in
    bundlerEnv {
      name = "${finalAttrs.pname}-gems-${finalAttrs.version}";
      inherit ruby;
      gemset = gemset';
      inherit (finalAttrs) version;
      gemdir = finalAttrs.src;
    };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = sources'.npmHash;
  };

  RAILS_ENV = "production";
  NODE_ENV = "production";
  REDIS_URL = ""; # build error if not defined
  TAILWINDCSS_INSTALL_DIR = "${tailwindcss_3}/bin";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    finalAttrs.dawarichGems
    finalAttrs.dawarichGems.wrappedRuby
  ];
  propagatedBuildInputs = [
    finalAttrs.dawarichGems.wrappedRuby
  ];
  buildInputs = [
    finalAttrs.dawarichGems
  ];

  buildPhase = ''
    runHook preBuild

    patchShebangs bin/
    for b in $(ls $dawarichGems/bin/)
    do
      if [ ! -f bin/$b ]; then
        ln -s $dawarichGems/bin/$b bin/$b
      fi
    done

    SECRET_KEY_BASE_DUMMY=1 bundle exec rake assets:precompile

    rm -rf node_modules tmp log storage
    ln -s /var/log/dawarich log
    ln -s /var/lib/dawarich storage
    ln -s /tmp tmp

    # delete more files unneeded at runtime
    rm -rf docker docs screenshots package.json package-lock.json *.md *.example

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv .{env*,ruby*,app_version} $out/
    mv * $out/

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) dawarich;
    };
    # run with: nix-shell ./maintainers/scripts/update.nix --argstr package dawarich
    updateScript = ./update.sh;
  };

  meta = {
    changelog = "https://github.com/Freika/dawarich/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Self-hostable alternative to Google Location History (Google Maps Timeline) ";
    homepage = "https://dawarich.app/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      diogotcorreia
    ];
    platforms = lib.platforms.linux;
  };
})
