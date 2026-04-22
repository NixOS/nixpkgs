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
  nodejs,
  openssh,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  stdenv,
  sqliteSupport ? true,
  nixosTests,
}:

let
  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "gitea-frontend";
    inherit (gitea) src version;

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 3;
      hash = "sha256-dewYYPO2wmNyYiQadoEKWJ10cghm6Lv7UE1iVlyNiEY=";
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];

    buildPhase = ''
      make frontend
    '';

    installPhase = ''
      mkdir -p $out
      cp -R public $out/
    '';
  });
in
buildGoModule rec {
  pname = "gitea";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "go-gitea";
    repo = "gitea";
    tag = "v${gitea.version}";
    hash = "sha256-BzO4VHyOShU8QB8re/2MzP+4vNGebY874aB9NQD8KVA=";
  };

  proxyVendor = true;

  vendorHash = "sha256-JSyjJIdRePbSnKL6GHdjx5Xbnsniq6KHOlEFsYvMmbw=";

  outputs = [
    "out"
    "data"
  ];

  patches = [ ./static-root-path.patch ];

  # go-modules derivation doesn't provide $data
  # so we need to wait until it is built, and then
  # at that time we can then apply the substituteInPlace
  overrideModAttrs = _: {
    postPatch = ''
      substituteInPlace go.mod \
        --replace-fail "go 1.26.2" "go 1.26"
    '';
  };

  postPatch = ''
    substituteInPlace modules/setting/server.go --subst-var data
    substituteInPlace go.mod \
      --replace-fail "go 1.26.2" "go 1.26"
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

  meta = {
    description = "Git with a cup of tea";
    homepage = "https://about.gitea.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      techknowlogick
      SuperSandro2000
    ];
    mainProgram = "gitea";
  };
}
