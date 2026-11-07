{
  bash,
  bundlerEnv,
  coreutils,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nixosTests,
  nodejs,
  ruby_3_4,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "postal";
  version = "3.3.7";

  src = fetchFromGitHub {
    owner = "postalserver";
    repo = "postal";
    tag = finalAttrs.version;
    hash = "sha256-x00TGhJJRUoe/lPVPBDicZ+La1FU7OxkPUba/0/tx0I=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [
    bash
  ];

  nativeBuildInputs = [
    makeWrapper
    nodejs
    finalAttrs.passthru.rubyEnv
    finalAttrs.passthru.rubyEnv.bundler
    finalAttrs.passthru.rubyEnv.wrappedRuby
  ];

  postPatch = ''
    echo ${finalAttrs.version} > VERSION
  '';

  buildPhase = ''
    runHook preBuild

    substituteInPlace bin/postal \
      --replace-fail "bundle" ${finalAttrs.passthru.rubyEnv}/bin/bundle \
      --replace-fail "script" $out/share/postal/script

    # Patch for systemd-notify support in puma, `eval` would
    # create a sub-process that breaks it
    substituteInPlace bin/postal \
      --replace-fail "eval \$@" "exec \$@"

    RAILS_GROUPS=assets ${finalAttrs.passthru.rubyEnv}/bin/bundle exec rake assets:precompile
    touch public/assets/.prebuilt

    # Always require lib-files and application.rb through their store
    # path, not their relative state directory path. This gets rid of
    # warnings and means we don't have to link back to lib from the
    # state directory.
    # Can't do this in patch phase as assets:recompile would otherwise fail
    find config script -type f -name "*.rb" -execdir \
      sed -Ei "s,(\.\./)+(lib|app)/,$out/share/postal/\2/," {} \;
    find config -maxdepth 1 -type f -name "*.rb" -execdir \
      sed -Ei "s,require_relative (\"|')([[:alnum:]].*)(\"|'),require_relative '$out/share/postal/config/\2'," {} \;

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{share,bin}
    cp -r . $out/share/postal

    makeWrapper $out/share/postal/bin/postal $out/bin/postal \
      --set PATH "${
        lib.makeBinPath [
          finalAttrs.passthru.rubyEnv.wrappedRuby
          coreutils
          nodejs
        ]
      }" \
      --set GEM_HOME "${finalAttrs.passthru.rubyEnv}/${finalAttrs.passthru.rubyEnv.ruby.gemPath}" \
      --chdir "$out/share/postal"

    runHook postInstall
  '';

  passthru = {
    rubyEnv = bundlerEnv {
      name = "postal-env-${finalAttrs.version}";
      ruby = ruby_3_4;
      gemdir = ./rubyEnv;
      groups = [
        "default"
        "oidc"
        "assets"
        "development"
        "test"
      ];
    };
    tests.postal = nixosTests.postal;
  };

  meta = {
    description = "Fully featured open source mail delivery platform for incoming & outgoing e-mail";
    homepage = "https://github.com/postalserver/postal";
    changelog = "https://github.com/postalserver/postal/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MatthieuBarthel ];
    mainProgram = "postal";
    platforms = finalAttrs.passthru.rubyEnv.ruby.meta.platforms;
  };
})
