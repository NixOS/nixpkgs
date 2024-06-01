{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, makeWrapper
, git
, bash
, coreutils
, gitea
, gzip
, openssh
, pam
, sqliteSupport ? true
, pamSupport ? true
, runCommand
, brotli
, xorg
, nixosTests
, buildNpmPackage
}:

let
  frontend = buildNpmPackage {
    pname = "gitea-frontend";
    inherit (gitea) src version;

    npmDepsHash = "sha256-gXBBiDIIS0aW6qK37HcF0AuJOliblinznRVXoo6DV1s=";

    # use webpack directly instead of 'make frontend' as the packages are already installed
    buildPhase = ''
      BROWSERSLIST_IGNORE_OLD_DATA=true npx webpack
    '';

    installPhase = ''
      mkdir -p $out
      cp -R public $out/
    '';
  };
in buildGoModule rec {
  pname = "gitea";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "go-gitea";
    repo = "gitea";
    rev = "v${gitea.version}";
    hash = "sha256-LdNEiPch2BZNYMOjE9yWsq78g6DolMjM5wUci3jXj30=";
  };

  vendorHash = "sha256-8VoJR4p2WnhG6nTFMzBlcrd/B6UwaOU3Q/rnDx9MtWc=";

  outputs = [ "out" "data" ];

  patches = [ ./static-root-path.patch ];

  # go-modules derivation doesn't provide $data
  # so we need to wait until it is built, and then
  # at that time we can then apply the substituteInPlace
  overrideModAttrs = _: { postPatch = null; };

  postPatch = ''
    substituteInPlace modules/setting/server.go --subst-var data
  '';

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = lib.optional pamSupport pam;

  tags = lib.optional pamSupport "pam"
    ++ lib.optionals sqliteSupport [ "sqlite" "sqlite_unlock_notify" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X 'main.Tags=${lib.concatStringsSep " " tags}'"
  ];

  postInstall = ''
    mkdir $data
    ln -s ${frontend}/public $data/public
    cp -R ./{templates,options} $data
    mkdir -p $out
    cp -R ./options/locale $out/locale

    wrapProgram $out/bin/gitea \
      --prefix PATH : ${lib.makeBinPath [ bash coreutils git gzip openssh ]}
  '';

  passthru = {
    data-compressed = runCommand "gitea-data-compressed" {
      nativeBuildInputs = [ brotli xorg.lndir ];
    } ''
      mkdir $out
      lndir ${gitea.data}/ $out/

      # Create static gzip and brotli files
      find -L $out -type f -regextype posix-extended -iregex '.*\.(css|html|js|svg|ttf|txt)' \
        -exec gzip --best --keep --force {} ';' \
        -exec brotli --best --keep --no-copy-stat {} ';'
    '';

    tests = nixosTests.gitea;
  };

  meta = with lib; {
    description = "Git with a cup of tea";
    homepage = "https://about.gitea.com";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 techknowlogick SuperSandro2000 ];
    broken = stdenv.isDarwin;
    mainProgram = "gitea";
  };
}
