{
  buildGoModule,
  fetchFromGitHub,
  iana-etc,
  installShellFiles,
  lib,
  libredirect,
  nix-update-script,
  stdenv,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "seaweedfs";
  version = "4.19";

  src = fetchFromGitHub {
    owner = "seaweedfs";
    repo = "seaweedfs";
    tag = finalAttrs.version;
    leaveDotGit = true;
    postFetch = ''
      pushd "$out"
      git rev-parse --short HEAD 2>/dev/null >$out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
      popd
    '';
    hash = "sha256-xMfV3WE10iP8MqxYd5w8JRUL5O7vO6ATN1ZEHB8MRxg=";
  };

  postPatch = ''
    # Remove unmaintained code that's not used and generates various issues.
    rm -rf unmaintained
  '';

  vendorHash = "sha256-mGiA91y6ebbbdAu0+ZDylUDuZb8vcNaqeGv70/IFx9k=";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libredirect.hook
  ];

  subPackages = [ "weed" ];

  tags = [
    "elastic"
    "gocdk"
    "rclone"
    "sqlite"
    "tarantool"
    "tikv"
    "ydb"
  ];

  ldflags = [
    "-s"
    "-extldflags=-static"
  ];

  env = {
    CGO_ENABLED = 0;
    GODEBUG = "http2client=0";
  };

  preBuild = ''
    ldflags+=" -X \"github.com/seaweedfs/seaweedfs/weed/util/version.COMMIT=$(<COMMIT)\""
  '';

  preCheck = ''
    # Test all targets.
    unset subPackages

    # Remove tests that require specialized environment or additional setup
    # that's not possible to achieve inside a sandbox.
    for i in test/{fuse_integration,kafka,s3,sftp,volume_server}; do
      find "$i" -name '*_test.go' -delete
    done

    # Required for reusing build artifacts in tests.
    export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
  ''
  + lib.optionalString (finalAttrs.env.CGO_ENABLED == 0) ''
    # Depends on CGO.
    rm -rf weed/mq/offset/{benchmark,end_to_end,sql_storage}_test.go
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/services=${iana-etc}/etc/services
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion \
        --cmd weed \
        --$shell <($out/bin/weed autocomplete $shell)
    done
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Simple and highly scalable distributed file system";
    longDescription = ''
      SeaweedFS is a versatile and efficient storage system designed to meet the
      needs of modern sysadmins managing a mix of blob, object, file, and data
      warehouse storage requirements. Its architecture guarantees fast access
      times, with constant-time (O(1)) disk seeks, regardless of the size of the
      dataset. This makes it an excellent choice for environments where speed
      and efficiency are critical.
    '';
    homepage = "https://github.com/seaweedfs/seaweedfs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      azahi
      cmacrae
      wozeparrot
    ];
    mainProgram = "weed";
  };
})
