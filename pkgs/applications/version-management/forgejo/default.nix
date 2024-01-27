{ bash
, brotli
, buildGoModule
, forgejo
, git
, gzip
, lib
, makeWrapper
, nix-update-script
, nixosTests
, openssh
, pam
, pamSupport ? true
, sqliteSupport ? true
, xorg
, runCommand
, stdenv
, fetchFromGitea
, buildNpmPackage
}:

let
  frontend = buildNpmPackage {
    pname = "forgejo-frontend";
    inherit (forgejo) src version;

    npmDepsHash = "sha256-nXQew6PR5z+FGzmD15WBclnOYxzNZxTmHypuzh5+7Ew=";

    patches = [
      ./package-json-npm-build-frontend.patch
    ];

    # override npmInstallHook
    installPhase = ''
      mkdir $out
      cp -R ./public $out/
    '';
  };
in
buildGoModule rec {
  pname = "forgejo";
  version = "1.21.4-0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "forgejo";
    repo = "forgejo";
    rev = "v${version}";
    hash = "sha256-m5y9lg1XAyOWA9jyeieGhzgJ9FaNorS45GCJPwMftXI=";
  };

  vendorHash = "sha256-eL3wxoRjxpkv012SqqifNLN9IOez5TbfGfZRgEX0AEM=";

  subPackages = [ "." ];

  outputs = [ "out" "data" ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optional pamSupport pam;

  patches = [
    ./../gitea/static-root-path.patch
  ];

  postPatch = ''
    substituteInPlace modules/setting/setting.go --subst-var data
  '';

  tags = lib.optional pamSupport "pam"
    ++ lib.optionals sqliteSupport [ "sqlite" "sqlite_unlock_notify" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X 'main.Tags=${lib.concatStringsSep " " tags}'"
  ];

  preBuild = ''
    go run build/merge-forgejo-locales.go
  '';

  postInstall = ''
    mkdir $data
    cp -R ./{templates,options} ${frontend}/public $data
    mkdir -p $out
    cp -R ./options/locale $out/locale
    wrapProgram $out/bin/gitea \
      --prefix PATH : ${lib.makeBinPath [ bash git gzip openssh ]}
  '';

  # $data is not available in goModules.drv and preBuild isn't needed
  overrideModAttrs = (_: {
    postPatch = null;
    preBuild = null;
  });

  passthru = {
    # allow nix-update to handle npmDepsHash
    inherit (frontend) npmDeps;

    data-compressed = runCommand "forgejo-data-compressed" {
      nativeBuildInputs = [ brotli xorg.lndir ];
    } ''
      mkdir $out
      lndir ${forgejo.data}/ $out/

      # Create static gzip and brotli files
      find -L $out -type f -regextype posix-extended -iregex '.*\.(css|html|js|svg|ttf|txt)' \
        -exec gzip --best --keep --force {} ';' \
        -exec brotli --best --keep --no-copy-stat {} ';'
    '';

    tests = nixosTests.forgejo;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A self-hosted lightweight software forge";
    homepage = "https://forgejo.org";
    changelog = "https://codeberg.org/forgejo/forgejo/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilylange urandom bendlas adamcstephens ];
    broken = stdenv.isDarwin;
    mainProgram = "gitea";
  };
}
