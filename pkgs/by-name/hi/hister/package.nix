{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  sqlite,
  yt-dlp-light,
  makeBinaryWrapper,
  nix-update-script,
  pkg-config,
  versionCheckHook,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "hister";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "hister";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8FKieCq7T87wIawCjVoto2kX1PU2sV1LFQtz2nydzBM=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-piPns+kq6ZCM4Bpe7nzdjHjkZKe1VV6UY9IIMshNGpo=";
  proxyVendor = true;

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [ sqlite ];

  tags = [ "libsqlite3" ];

  preBuild = ''
    mkdir -p server/static/app
    cp -r ${finalAttrs.passthru.frontend}/* server/static/app/
  '';

  ldflags = [
    "-s"
  ];

  subPackages = [ "." ];

  postInstall = ''
    wrapProgram $out/bin/hister \
      --prefix PATH : ${lib.makeBinPath [ yt-dlp-light ]}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    frontend = (buildNpmPackage.override { nodejs = nodejs_22; }) {
      pname = "${finalAttrs.pname}-frontend";
      inherit (finalAttrs) version src;

      strictDeps = true;

      npmWorkspace = "webui/app";
      npmDepsFetcherVersion = 2;
      npmDepsHash = "sha256-9mcUiua8bKiGRDAJmGSQeRsbfdN4P2r/tcCzr7D0Ay4=";

      # vite 8's rolldown pipeline does a dns.lookup('localhost') during `vite build`
      # which fails in darwin's relaxed sandbox without loopback access
      __darwinAllowLocalNetworking = true;

      preBuild = ''
        patchShebangs webui
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp -r webui/app/build/* "$out/"
        runHook postInstall
      '';
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
    tests = { inherit (nixosTests) hister; };
  };

  meta = {
    changelog = "https://github.com/asciimoo/hister/releases/tag/v${finalAttrs.version}";
    description = "Web history on steroids - blazing fast, content-based search for visited websites";
    homepage = "https://github.com/asciimoo/hister";
    license = lib.licenses.agpl3Plus;
    mainProgram = "hister";
    maintainers = with lib.maintainers; [ _4evy ];
    platforms = lib.platforms.unix;
  };
})
