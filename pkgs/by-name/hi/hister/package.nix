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
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "hister";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yX/MGhGyQxE5cSe1Q4T9EEBwRS5mxUBtpkn/RnGN4lU=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  vendorHash = "sha256-UR384CLSa44MqPVzzgzGZC/ROdG2iWtJ5L8AX/tfg0k=";
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
      npmDepsHash = "sha256-iCr+5HMxb4GLkkY2Ql6v+AXAb5U6Q/Yp+N83soJGbGI=";

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
