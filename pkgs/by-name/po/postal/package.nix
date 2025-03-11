{
  bundlerEnv,
  lib,
  stdenv,
  defaultGemConfig,
  fetchFromGitHub,
  ruby_3_3,
  nodejs,
  makeWrapper,
  coreutils,
  nixosTests,
}:

let
  version = "3.3.4";
  src = fetchFromGitHub {
    owner = "postalserver";
    repo = "postal";
    tag = version;
    hash = "sha256-4eXBEM0O4G6ZyfhFP1dXYN7Wx99dDdcy85MygBDKwks=";
  };

  rubyEnv = bundlerEnv rec {
    name = "postal-env-${version}";
    ruby = ruby_3_3;
    gemdir = ./rubyEnv;
    gemset = import (gemdir + "/gemset.nix");
    groups = [
      "default"
      "oidc"
      "assets"
      "development"
    ];
    gemConfig = defaultGemConfig;
  };
in
stdenv.mkDerivation rec {
  inherit version src;
  pname = "postal";

  buildInputs = [
    rubyEnv
    rubyEnv.wrappedRuby
    rubyEnv.bundler
    nodejs
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postPatch = ''
    echo ${version} > VERSION
  '';

  buildPhase = ''
    runHook preBuild

    substituteInPlace bin/postal \
      --replace-fail "bundle" ${rubyEnv}/bin/bundle \
      --replace-fail "script" $out/share/postal/script

    # Patch for systemd-notify support in puma, `eval` would
    # create a sub-process that breaks it
    substituteInPlace bin/postal \
      --replace-fail "eval \$@" "exec \$@"

    RAILS_GROUPS=assets ${rubyEnv}/bin/bundle exec rake assets:precompile
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
    mkdir -p $out/{share,bin}
    cp -r . $out/share/postal

    makeWrapper $out/share/postal/bin/postal $out/bin/postal \
      --set PATH "${
        lib.makeBinPath [
          rubyEnv.wrappedRuby
          coreutils
          nodejs
        ]
      }" \
      --set GEM_HOME "${rubyEnv}/${rubyEnv.ruby.gemPath}" \
      --chdir "$out/share/postal"
  '';

  passthru.tests.postal = nixosTests.postal;

  meta = {
    description = "Fully featured open source mail delivery platform for incoming & outgoing e-mail";
    homepage = "https://github.com/postalserver/postal";
    changelog = "https://github.com/postalserver/postal/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MatthieuBarthel ];
    mainProgram = "postal";
    platforms = rubyEnv.ruby.meta.platforms;
  };
}
