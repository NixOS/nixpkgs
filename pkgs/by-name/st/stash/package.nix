{ lib
, stdenv
, fetchFromGitHub
, mkYarnPackage
, fetchYarnDeps
, buildGoModule
, darwin
, makeWrapper
, ffmpeg-full
, vips
}:

let
  pname = "stash";
  version = "0.24.3";

  # these hashes can be updated by update.sh
  gitHash = "aeb68a58";
  srcHash = "sha256-5JmxPNf2/A00VUO94k3MoB+28VmY/ejLAa56JQsiVRc=";
  yarnHash = "sha256-yyc9M5sLVygk9KoP7mIlpsJGzbhXJwHYuUZG0MlV5MM=";

  src = fetchFromGitHub {
    owner = "stashapp";
    repo = pname;
    rev = "v${version}";
    hash = srcHash;
  };
  uiSrc = "${src}/ui/v2.5";

  ui = mkYarnPackage {
    inherit version;
    pname = "${pname}-ui";
    src = uiSrc;

    packageJSON = ./package.json;

    offlineCache = fetchYarnDeps {
      yarnLock = "${uiSrc}/yarn.lock";
      hash = yarnHash;
    };

    postPatch = ''
      substituteInPlace codegen.yml \
        --replace "../../graphql/" "${src}/graphql/"
    '';

    configurePhase = ''
      ln -s $node_modules node_modules
    '';

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      export VITE_APP_DATE="1970-01-01 00:00:00"
      export VITE_APP_GITHASH=${gitHash}
      export VITE_APP_STASH_VERSION=v${version}
      export VITE_APP_NOLEGACY=true

      yarn --offline run gqlgen
      yarn --offline build
      mv build $out

      runHook postBuild
    '';

    distPhase = "true";
    dontInstall = true;
    dontFixup = true;
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-GdVNf3o1MFDRYgR3MLpNCU605Bdmz8QBIII4JcDkTGY=";

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/stashapp/stash/internal/build.buildstamp=1970-01-01 00:00:00'"
    "-X 'github.com/stashapp/stash/internal/build.githash=${gitHash}'"
    "-X 'github.com/stashapp/stash/internal/build.version=v${version}'"
    "-X 'github.com/stashapp/stash/internal/build.officialBuild=true'"
  ];
  tags = [ "sqlite_stat4" ];

  subPackages = [ "cmd/stash" ];

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Cocoa WebKit ]);

  nativeBuildInputs = [ makeWrapper ];

  preBuild = ''
    cp -a ${ui} ui/v2.5/build

    # `go mod tidy` requires internet access and does nothing
    echo "skip_mod_tidy: true" >> gqlgen.yml

    # remove `-trimpath` fron `GOFLAGS` because `gqlgen` does not work with it
    GOFLAGS="''${GOFLAGS/-trimpath/}" go generate ./cmd/stash
  '';

  postFixup = ''
    wrapProgram $out/bin/stash --prefix PATH : "${lib.makeBinPath [ ffmpeg-full vips ]}"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "An organizer for your porn, written in Go.";
    homepage = "https://stashapp.cc/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    platforms = lib.platforms.all;
    mainProgram = "stash";
  };
}
