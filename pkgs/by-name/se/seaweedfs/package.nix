{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  stdenv,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "seaweedfs";
  version = "4.36";

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
    hash = "sha256-y42opbGNVMxWU/k0j5g27RWLBF0PLcOPlXU9eVg0jwY=";
  };

  vendorHash = "sha256-peRhKuZ1D+y8Uhw1+P8Ogc1HrOh1/kYVd29lR89+rIo=";

  nativeBuildInputs = [ installShellFiles ];

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
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "-extldflags=-static"
  ];

  env = {
    CGO_ENABLED = if stdenv.hostPlatform.isDarwin then 1 else 0;
    GODEBUG = "http2client=0";
  };

  preBuild = ''
    ldflags+=" -X \"github.com/seaweedfs/seaweedfs/weed/util/version.COMMIT=$(<COMMIT)\""
  '';

  # Tests frequently break (mostly because of sandboxing) and keeping track of
  # changes every release is becoming too much of a hassle resulting in Nixpkgs
  # versions lagging behind which is not ideal for a package with a rapid
  # release cycle.
  doCheck = false;

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
