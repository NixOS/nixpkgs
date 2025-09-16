{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gdu";
  version = "5.31.0";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = "gdu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MAkD4Mh7aXWc8Y4TkXH7NSDgPQugB7Gjhr4nfOr/X1U=";
  };

  vendorHash = "sha256-aKhHC3sPRyi/l9BxeUgx+3TdYulb0cI9WxuPvbLoswg=";

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/dundee/gdu/v${lib.versions.major finalAttrs.version}/build.Version=${finalAttrs.version}"
  ];

  postPatch = ''
    substituteInPlace cmd/gdu/app/app_test.go \
      --replace-fail "development" "${finalAttrs.version}"
  '';

  postInstall = ''
    installManPage gdu.1
  '';

  doCheck = !stdenv.hostPlatform.isDarwin;

  checkFlags = [
    # https://github.com/dundee/gdu/issues/371
    "-skip=TestStoredAnalyzer"
    "-skip=TestAnalyzePathWithIgnoring"
  ];

  doInstallCheck = true;

  meta = {
    description = "Disk usage analyzer with console interface";
    longDescription = ''
      Gdu is intended primarily for SSD disks where it can fully
      utilize parallel processing. However HDDs work as well, but
      the performance gain is not so huge.
    '';
    homepage = "https://github.com/dundee/gdu";
    changelog = "https://github.com/dundee/gdu/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      fab
      zowoq
    ];
    mainProgram = "gdu";
  };
})
