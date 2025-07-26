{
  lib,
  nixosTests,
  stdenv,
  fetchNpmDeps,
  nodejs,
  bundlerEnv,
  callPackage,
  ruby_3_4,
  npmHooks,
  tailwindcss_3,
  version ? srcOverride.version,
  patches ? [ ],
  # src is a package
  srcOverride ? callPackage ./source.nix { inherit patches; },
  gemset ? ./. + "/gemset.nix",
  npmHash ? srcOverride.npmHash,
}:
let
  ruby = ruby_3_4;
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "dawarich";

  src = srcOverride;

  dawarichGems = bundlerEnv {
    name = "${finalAttrs.pname}-gems-${finalAttrs.version}";
    inherit version gemset ruby;
    gemdir = finalAttrs.src;
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = npmHash;
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
    updateScript = ./update.sh; # TODO
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
