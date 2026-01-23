{
  lib,
  applyPatches,
  bundlerEnv,
  fetchFromGitHub,
  fetchNpmDeps,
  nixosTests,
  nodejs,
  npmHooks,
  ruby_3_4,
  stdenv,
  tailwindcss_3,
  gemset ? import ./gemset.nix,
  sources ? lib.importJSON ./sources.json,
  unpatchedSource ? fetchFromGitHub {
    owner = "Freika";
    repo = "dawarich";
    tag = sources.version;
    inherit (sources) hash;
  },
}:
let
  ruby = ruby_3_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dawarich";
  inherit (sources) version;

  # Use `applyPatches` here because bundix in the update script (see ./update.sh)
  # needs to run on the already patched Gemfile and Gemfile.lock.
  # Only patches changing these two files should be here;
  # patches for other parts of the application should go directly into mkDerivation.
  src = applyPatches {
    src = unpatchedSource;
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

  postPatch = ''
    # move import directory to a more convenient place, otherwise its behind systemd private tmp
    substituteInPlace ./app/services/imports/watcher.rb \
      --replace-fail 'tmp/imports/watched' 'storage/imports/watched'
  '';

  dawarichGems = bundlerEnv {
    name = "${finalAttrs.pname}-gems-${finalAttrs.version}";
    inherit gemset ruby;
    inherit (finalAttrs) version;
    gemdir = finalAttrs.src;
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = sources.npmHash;
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

    # tests are not needed at runtime
    rm -rf spec e2e
    # delete artifacts from patching
    rm *.orig

    mkdir -p $out
    mv .{ruby*,app_version} $out/
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
    description = "Self-hostable alternative to Google Location History (Google Maps Timeline)";
    homepage = "https://dawarich.app/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      diogotcorreia
    ];
    platforms = lib.platforms.linux;
  };
})
