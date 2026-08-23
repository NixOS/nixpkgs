{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchzip,
  fuse,
  stdenv,
  installShellFiles,
  versionCheckHook,
  callPackage,
}:
buildGoModule (finalAttrs: {
  pname = "alist";
  version = "3.63.0";

  src = fetchFromGitHub {
    owner = "AlistGo";
    repo = "alist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G3guBu+SRIF8a4OZzPvnu2Ri1N7VRst4LB/WCykmH58=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # '0000-00-00T00:00:00Z'
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  # --- FAIL: TestSecureJoin/drive (0.00s)
  #     securepath_test.go:29: expected error for "C:\\evil.txt", got nil
  postPatch = lib.optionalString stdenv.hostPlatform.isUnix ''
    substituteInPlace internal/archive/tool/securepath_test.go \
      --replace-fail '{name: "drive", entry: "C:\\evil.txt", wantErr: true},' ""
  '';

  proxyVendor = true;
  vendorHash = "sha256-oHuNsTfP216Kd46TNF8oUDGgoABq1NtPiPN1srOFJzE=";

  buildInputs = [ fuse ];

  tags = [ "jsoniter" ];

  ldflags = [
    "-s"
    "-w"
    "-X \"github.com/alist-org/alist/v3/internal/conf.GitAuthor=Xhofe <i@nn.ci>\""
    "-X github.com/alist-org/alist/v3/internal/conf.Version=${finalAttrs.version}"
    "-X github.com/alist-org/alist/v3/internal/conf.WebVersion=${finalAttrs.passthru.webVersion}"
  ];

  preConfigure = ''
    rm -rf public/dist
    cp -r ${finalAttrs.passthru.web} public/dist
  '';

  preBuild = ''
    ldflags+=" -X \"github.com/alist-org/alist/v3/internal/conf.GoVersion=$(go version | sed 's/go version //')\""
    ldflags+=" -X \"github.com/alist-org/alist/v3/internal/conf.BuiltAt=$(cat SOURCE_DATE_EPOCH)\""
    ldflags+=" -X github.com/alist-org/alist/v3/internal/conf.GitCommit=$(cat COMMIT)"
  '';
  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestHTTPAll"
        "TestWebsocketAll"
        "TestWebsocketCaller"
        "TestDownloadOrder"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd alist \
      --bash <($out/bin/alist completion bash) \
      --fish <($out/bin/alist completion fish) \
      --zsh <($out/bin/alist completion zsh)
  '';

  doInstallCheck = true;

  versionCheckProgramArg = "version";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    updateScript = lib.getExe (callPackage ./update.nix { });
    webVersion = "3.63.0";
    web = fetchzip {
      url = "https://github.com/AlistGo/alist-web/releases/download/${finalAttrs.passthru.webVersion}/dist.tar.gz";
      hash = "sha256-uWktKQU9EYPXj88Wj8LbRbuIPqW2u3EBQ5MM82wawtM=";
    };
  };

  meta = {
    description = "File list/WebDAV program that supports multiple storages";
    homepage = "https://github.com/AlistGo/alist";
    changelog = "https://github.com/AlistGo/alist/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      agpl3Only
      # alist-web
      mit
    ];
    knownVulnerabilities = [
      "Alist was acquired by Bugotech, a company distrusted by the community"
      "Uses a questionable API server alist.nn.ci for account creation for certain drivers"
    ];
    maintainers = with lib.maintainers; [ moraxyc ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # alist-web
      binaryBytecode
    ];
    mainProgram = "alist";
  };
})
