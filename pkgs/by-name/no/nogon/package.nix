{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  sqlite,
  yt-dlp-light,
  makeBinaryWrapper,
  nix-update-script,
  pkg-config,
  versionCheckHook,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "nogon";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "nogon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tzaB2PmBtxJQlMy/4FV0ZwARmjmtu6VFa8j9pCAxS0s=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-BXs1VMZWxoLXvI2hDeiJoJIFwpz2xPCHg7NzegNrJ8o=";
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
    wrapProgram $out/bin/nogon \
      --prefix PATH : ${lib.makeBinPath [ yt-dlp-light ]}
    ln -s nogon $out/bin/hister
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    frontend = buildNpmPackage {
      pname = "nogon-frontend";
      inherit (finalAttrs) version src;

      strictDeps = true;

      npmWorkspace = "webui/app";
      npmDepsFetcherVersion = 2;
      npmDepsHash = "sha256-H15/vZbtJWqswRCLDPKcGJ2mvkek4Umo8V8G0dHaJW8=";

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
    tests = { inherit (nixosTests) nogon; };
  };

  meta = {
    changelog = "https://github.com/asciimoo/nogon/releases/tag/v${finalAttrs.version}";
    description = "Web history on steroids - blazing fast, content-based search for visited websites";
    downloadPage = "https://github.com/asciimoo/nogon";
    homepage = "https://nogon.eu";
    license = lib.licenses.agpl3Plus;
    mainProgram = "nogon";
    maintainers = with lib.maintainers; [ _4evy ];
    platforms = lib.platforms.unix;
    teams = with lib.teams; [ ngi ];
  };
})
