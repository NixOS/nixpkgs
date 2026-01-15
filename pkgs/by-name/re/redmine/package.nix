{
  lib,
  stdenvNoCC,
  fetchurl,
  bundlerEnv,
  ruby_3_3,
  makeWrapper,
  nixosTests,
}:

let
  version = "6.1.1";
  rubyEnv = bundlerEnv {
    name = "redmine-env-${version}";

    inherit ruby_3_3;
    gemdir = ./.;
    groups = [
      "development"
      "ldap"
      "markdown"
      "common_mark"
      "minimagick"
      "test"
    ];
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "redmine";
  inherit version;

  src = fetchurl {
    url = "https://www.redmine.org/releases/redmine-${finalAttrs.version}.tar.gz";
    hash = "sha256-Hy5t0GlwYvxzNwH4i1BB3A38a1NiVet5AvIfsJcOYD4=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    rubyEnv
    rubyEnv.wrappedRuby
    rubyEnv.bundler
  ];

  buildPhase = ''
    mv config config.dist
    mv themes themes.dist
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp -r . $out/share/redmine
    mkdir $out/share/redmine/public/assets
    for i in config files log plugins public/assets public/plugin_assets themes tmp; do
      rm -rf $out/share/redmine/$i
      ln -fs /run/redmine/$i $out/share/redmine/$i
    done

    makeWrapper ${rubyEnv.wrappedRuby}/bin/ruby $out/bin/rdm-mailhandler.rb --add-flags $out/share/redmine/extra/mail_handler/rdm-mailhandler.rb
  '';

  passthru.tests.redmine = nixosTests.redmine;

  meta = {
    homepage = "https://www.redmine.org/";
    changelog = "https://www.redmine.org/projects/redmine/wiki/changelog";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      aanderse
      felixsinger
      megheaiulian
    ];
    license = lib.licenses.gpl2;
  };
})
