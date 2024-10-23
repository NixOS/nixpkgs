{
  bundlerEnv,
  lib,
  stdenv,
  defaultGemConfig,
  fetchFromGitHub,
  ruby_3_2,
  nodejs,
  makeWrapper,
  coreutils,
  testers,
  postal,
}:

let
  version = "3.3.4";
  src = fetchFromGitHub {
    owner = "postalserver";
    repo = "postal";
    rev = version;
    hash = "sha256-4eXBEM0O4G6ZyfhFP1dXYN7Wx99dDdcy85MygBDKwks=";
  };

  rubyEnv = bundlerEnv rec {
    name = "postal-env-${version}";
    ruby = ruby_3_2;
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
      --replace-fail "bundle" ${rubyEnv}/bin/bundle

    substituteInPlace bin/postal \
      --replace-fail "script" $out/share/postal/script

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
    rm -rf $out/share/postal/log
    ln -sf /run/postal/log $out/share/postal/log
    ln -sf /run/postal/uploads $out/share/postal/public/uploads
    ln -sf /run/postal/config $out/share/postal/config
    ln -sf /run/postal/tmp $out/share/postal/tmp

    makeWrapper $out/share/postal/bin/postal $out/bin/postal \
      --set PATH "${
        lib.makeBinPath [
          rubyEnv.wrappedRuby
          coreutils
        ]
      }" \
      --set GEM_HOME "${rubyEnv}/${rubyEnv.ruby.gemPath}" \
      --chdir "$out/share/postal"
  '';

  passthru = {
    inherit rubyEnv;
    ruby = rubyEnv.wrappedRuby;
    tests.version = testers.testVersion {
      package = postal;
      command = "postal version";
    };
  };

  meta = {
    description = "A fully featured open source mail delivery platform for incoming & outgoing e-mail";
    homepage = "https://github.com/postalserver/postal";
    changelog = "https://github.com/postalserver/postal/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xanderio ];
    mainProgram = "postal";
    platforms = rubyEnv.ruby.meta.platforms;
  };
}
