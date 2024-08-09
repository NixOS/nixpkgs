{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  bundlerEnv,
  nixosTests,
  ruby_3_3,
}:
let
  version = "1.6.3";
  src = fetchFromGitHub {
    owner = "docusealco";
    repo = "docuseal";
    rev = version;
    hash = "sha256-8RvtDyk7iD5lDgLhYEgB6qG2LT1UhnsiAm7zO8aBrDw=";
  };
  meta = with lib; {
    description = "Open source DocuSign alternative. Create, fill, and sign digital documents.";
    homepage = "https://www.docuseal.co/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.unix;
  };

  bundler = bundler.override { ruby = ruby_3_3; };
  rubyEnv = bundlerEnv {
    name = "docuseal-gems";
    ruby = ruby_3_3;
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
stdenv.mkDerivation rec {
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
      docuseal-psql = nixosTests.docuseal-postgresql;
      docuseal-sqlite = nixosTests.docuseal-sqlite;
    };
    updateScript = ./update.sh;
  };
}
