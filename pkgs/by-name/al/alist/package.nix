{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchzip,
  fuse,
  stdenv,
  installShellFiles,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "alist";
  version = "3.40.0";
  webVersion = "3.39.2";

  src = fetchFromGitHub {
    owner = "AlistGo";
    repo = "alist";
    rev = "refs/tags/v${version}";
    hash = "sha256-2cpYe00OoTLvbN2BeB50wiAcfrrXCp3DXb5xCZaVMPA=";
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
  web = fetchzip {
    url = "https://github.com/AlistGo/alist-web/releases/download/${webVersion}/dist.tar.gz";
    hash = "sha256-vc/pwu6TohHVydhMJ5xOXPLogV0WodT/YnGIXtIsLlk=";
  };

  proxyVendor = true;
  vendorHash = "sha256-S8TPu+pOljrA8GAeCzxgv09pb5rauSYvRm8gt8oMPTs=";

  buildInputs = [ fuse ];

  tags = [ "jsoniter" ];

  ldflags = [
    "-s"
    "-w"
    "-X \"github.com/alist-org/alist/v3/internal/conf.GitAuthor=Xhofe <i@nn.ci>\""
    "-X github.com/alist-org/alist/v3/internal/conf.Version=${version}"
    "-X github.com/alist-org/alist/v3/internal/conf.WebVersion=${webVersion}"
  ];

  preConfigure = ''
    rm -rf public/dist
    cp -r ${web} public/dist
  '';

  preBuild = ''
    ldflags+=" -X \"github.com/alist-org/alist/v3/internal/conf.GoVersion=$(go version | sed 's/go version //')\""
    ldflags+=" -X \"github.com/alist-org/alist/v3/internal/conf.BuiltAt=$(cat SOURCE_DATE_EPOCH)\""
    ldflags+=" -X github.com/alist-org/alist/v3/internal/conf.GitCommit=$(cat COMMIT)"
  '';

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestHTTPAll"
        "TestWebsocketAll"
        "TestWebsocketCaller"
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

  meta = {
    description = "File list/WebDAV program that supports multiple storages";
    homepage = "https://github.com/alist-org/alist";
    changelog = "https://github.com/alist-org/alist/releases/tag/v${version}";
    license = with lib.licenses; [
      agpl3Only
      # alist-web
      mit
    ];
    maintainers = with lib.maintainers; [ moraxyc ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # alist-web
      binaryBytecode
    ];
    mainProgram = "alist";
  };
}
