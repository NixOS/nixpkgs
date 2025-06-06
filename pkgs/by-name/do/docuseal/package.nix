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
  version = "1.7.9";
  src = fetchFromGitHub {
    owner = "docusealco";
    repo = "docuseal";
    rev = version;
    hash = "sha256-fz06oDC4zk12sLwHZG/lnDZmoXvxZz7e2zIVG4v5DFo=";
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
