{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  writableTmpDirAsHomeHook,
  gopass,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "git-credential-gopass";
  version = "1.17.3";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "git-credential-gopass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aVH4C8KVJusUxgU+EtQSdlV432y2fB6M215i1jHzY70=";
  };

  vendorHash = "sha256-vjKqYKycTcal6YQG1kFPvWVxZGfnatB3UzkW9uIUOWM=";

  subPackages = [ "." ];

  nativeBuildInputs = [
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/git-credential-gopass \
      --prefix PATH : "${gopass.wrapperPath}"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    gopass
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  preVersionCheck = ''
    gopass setup --name "user" --email "user@localhost"
  '';

  meta = {
    description = "Manage git credentials using gopass";
    homepage = "https://github.com/gopasspw/git-credential-gopass";
    changelog = "https://github.com/gopasspw/git-credential-gopass/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benneti ];
    mainProgram = "git-credential-gopass";
  };
})
