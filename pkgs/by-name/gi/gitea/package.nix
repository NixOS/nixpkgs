{
  lib,
  buildGo127Module,
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
  pnpm_11,
  stdenv,
  sqliteSupport ? true,
  nixosTests,
}:

let
  pnpm = pnpm_11;

  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "gitea-frontend";
    inherit (gitea) src version;

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 4;
      hash = "sha256-Q8PJfQ5RPKM1upeujKLd5msANQRj+Fjwz/Q+lqov0yI=";
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];

    __darwinAllowLocalNetworking = true;

    buildPhase = ''
      make frontend
    '';

    installPhase = ''
      mkdir -p $out
      cp -R public $out/
    '';
  });
in
buildGo127Module (finalAttrs: {
  pname = "gitea";
  version = "28.1.0";

  outputs = [
    "out"
    "data"
  ];

  src = fetchFromGitHub {
    owner = "go-gitea";
    repo = "gitea";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5lJ1ZpQViTOkw8XGwnCjMsKFFcsbnPhR0HyRZjTRQPU=";
  };

  proxyVendor = true;

  vendorHash = "sha256-Khz02FbO01nKwhFfEgAwCRw5YsGS4hW9vl1JJGDS7fs=";

  postPatch = ''
    substituteInPlace modules/setting/server.go \
      --replace-fail '"gitea.dev/modules/util"' "" \
      --replace-fail "StaticRootPath = util.IfZero(StaticRootPath, AppWorkPath)" "StaticRootPath = \"$data\""
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
    "-X main.Version=${finalAttrs.version}"
    "-X 'main.Tags=${lib.concatStringsSep " " finalAttrs.tags}'"
  ];

  postInstall = ''
    mkdir $data
    ln -s ${frontend}/public $data/public
    cp -R ./{templates,options} $data
    mkdir -p $out
    cp -R ./options/locale $out/locale

    mv $out/bin/gitea{.dev,}
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

    tests = {
      inherit (nixosTests) gitea gitea-actions-runner;
    };
  };

  meta = {
    description = "Git with a cup of tea";
    homepage = "https://about.gitea.com";
    changelog = "https://github.com/go-gitea/gitea/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      techknowlogick
      SuperSandro2000
    ];
    mainProgram = "gitea";
  };
})
