{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  bundlerEnv,
  nixosTests,
  ruby,
}:
let
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "docusealco";
    repo = "docuseal";
    rev = version;
    hash = "sha256-sKvD89hQRAVZ7r7Gdn6rZrFXh+P6gctR6C5AewcK4QU=";
    # https://github.com/docusealco/docuseal/issues/505#issuecomment-3153802333
    postFetch = "rm $out/db/schema.rb";
  };
  meta = with lib; {
    description = "Open source DocuSign alternative. Create, fill, and sign digital documents.";
    homepage = "https://www.docuseal.co/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.unix;
  };

  bundler = bundler.override { ruby = ruby; };
  rubyEnv = bundlerEnv {
    name = "docuseal-gems";
    ruby = ruby;
    inherit bundler;
    gemdir = ./.;
  };

  web = callPackage ./web.nix {
    inherit
      version
      src
      meta
      rubyEnv
      ;
  };
in
stdenv.mkDerivation {
  pname = "docuseal";
  inherit version src meta;

  buildInputs = [ rubyEnv ];
  propagatedBuildInputs = [ rubyEnv.wrappedRuby ];

  RAILS_ENV = "production";
  BUNDLE_WITHOUT = "development:test";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/public/packs
    cp -r ${src}/* $out
    cp -r ${web}/* $out/public/packs/

    bundle exec bootsnap precompile --gemfile app/ lib/

    runHook postInstall
  '';

  # create empty folder which are needed, but never used
  postInstall = ''
    chmod +w $out/tmp/
    mkdir -p $out/tmp/{cache,sockets}
  '';

  passthru = {
    tests = {
      inherit (nixosTests) docuseal-postgresql docuseal-sqlite;
    };
    updateScript = ./update.sh;
  };
}
