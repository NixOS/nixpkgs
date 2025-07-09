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

  gemset ? ./. + "/gemset.nix",
}:
let
  ruby = ruby_3_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dawarich";
  version = "0.30.6";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "Freika";
      repo = "dawarich";
      tag = finalAttrs.version;
      hash = "sha256-2WXu7Y2lujRvi0fFaUEIp5qTEV4AC5zsGV5vtQ/oiNo=";

    };
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
    ./0001-redis-url-database.diff
  ];

  dawarichGems = bundlerEnv {
    name = "${finalAttrs.pname}-gems-${finalAttrs.version}";
    inherit gemset ruby;
    inherit (finalAttrs) version;
    gemdir = finalAttrs.src;
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-+GfnyecDI+boIeZOyiluWnbUfF+NgeXg9ywfH7ZmccA=";
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
