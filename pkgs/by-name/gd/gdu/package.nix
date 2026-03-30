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
  version = "5.34.4";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = "gdu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dt16bq0I//ptofT3s2OnU6C4Rd4itov9+Rzz7jai6hw=";
  };

  vendorHash = "sha256-Dtjirx2sHbN4AWxED5weRGtCRNc2VIdaz7RHssGuJeQ=";

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

  checkFlags =
    let
      skippedTests = [
        "TestStoredAnalyzer" # https://github.com/dundee/gdu/issues/371
        "TestAnalyzePathWithIgnoring"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

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
