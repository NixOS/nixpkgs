{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  git,
  bash,
  coreutils,
  compressDrvWeb,
  gitea,
  gzip,
  openssh,
  sqliteSupport ? true,
  nixosTests,
  buildNpmPackage,
}:

let
  frontend = buildNpmPackage {
    pname = "gitea-frontend";
    inherit (gitea) src version;

    npmDepsHash = "sha256-+o7/A+Pqr8LZi+q0fOajQgLkWqquBrJSf0dpEXEJtwM=";

    # use webpack directly instead of 'make frontend' as the packages are already installed
    buildPhase = ''
      BROWSERSLIST_IGNORE_OLD_DATA=true npx webpack
    '';

    installPhase = ''
      mkdir -p $out
      cp -R public $out/
    '';
  };
in
buildGoModule rec {
  pname = "gitea";
  version = "1.24.3";

  src = fetchFromGitHub {
    owner = "go-gitea";
    repo = "gitea";
    tag = "v${gitea.version}";
    hash = "sha256-z9GaUkBh/hfDKkygi/1U0tK725mj39eBR906QKn3MWU=";
  };

  proxyVendor = true;

  vendorHash = "sha256-VmlF86Sv6R2NmCtWi4kZ4rfmFAjgMB1RU/1jmnPiIkw=";

  outputs = [
    "out"
    "data"
  ];

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

  tags = lib.optionals sqliteSupport [
    "sqlite"
    "sqlite_unlock_notify"
  ];

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
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          git
          gzip
          openssh
        ]
      }
  '';

  passthru = {
    data-compressed =
      lib.warn "gitea.passthru.data-compressed is deprecated. Use \"compressDrvWeb gitea.data\"."
        (compressDrvWeb gitea.data { });

    tests = nixosTests.gitea;
  };

  meta = with lib; {
    description = "Git with a cup of tea";
    homepage = "https://about.gitea.com";
    license = licenses.mit;
    maintainers = with maintainers; [
      techknowlogick
      SuperSandro2000
    ];
    mainProgram = "gitea";
  };
}
