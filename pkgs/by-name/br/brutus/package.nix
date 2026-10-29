{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "brutus";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "brutus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pTDTme0jPf3yy6Yds46bDhVWZhUiB4drTUbA+ywouNA=";
  };

  vendorHash = "sha256-Z0W3lLYGeacKf+mcqRcab06+8fFKoHDDzXomDRYB1pg=";

  ldflags = [
    "-s"
    "-X=main.Version=${finalAttrs.version}"
    "-X=main.BuildTime=1970-01-01T00:00:00Z"
    "-X=main.CommitSHA=${finalAttrs.src.rev}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "--version" ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  preCheck = ''
    # Tests require network access
    substituteInPlace pkg/enum/google/google_test.go \
      --replace-fail "TestCheckAccount_SendsBrowserUserAgent" "Skip_TestCheckAccount_SendsBrowserUserAgent"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Credential testing tool for multiple services";
    homepage = "https://github.com/praetorian-inc/brutus";
    changelog = "https://github.com/praetorian-inc/brutus/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "brutus";
  };
})
