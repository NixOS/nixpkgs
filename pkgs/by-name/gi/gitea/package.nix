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
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "gitea";
  version = "28.3.0";

  outputs = [
    "out"
    "data"
  ];

  src = fetchFromGitHub {
    owner = "go-gitea";
    repo = "gitea";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y+sawjuhvZn9HBnrfzXtdBwH3i3oXQBYNoRhpsmdURY=";
  };

  proxyVendor = true;

  vendorHash = "sha256-H57+G/LeZobc6yzkeCdX4aPTc0mKdYUCTxOQFxzCeL4=";

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

  frontend = stdenv.mkDerivation (finalFrontendAttrs: {
    pname = "${finalAttrs.pname}-frontend";
    inherit (finalAttrs) src version;

    pnpmDeps = fetchPnpmDeps {
      inherit (finalFrontendAttrs) pname version src;
      pnpm = pnpm_11;
      fetcherVersion = 4;
      hash = "sha256-Q8PJfQ5RPKM1upeujKLd5msANQRj+Fjwz/Q+lqov0yI=";
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_11
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

  postInstall = ''
    mkdir $data
    ln -s ${finalAttrs.frontend}/public $data/public
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

    tests = nixosTests.gitea;

    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
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
