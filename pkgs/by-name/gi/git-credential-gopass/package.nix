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
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "git-credential-gopass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V+SEkV4I925S6sL9YC0QtEp76xENUaQO+XixWzsSqvs=";
  };

  vendorHash = "sha256-OgwsQQRaJSwdh0+n1FdqAJzJ4pyggaejwg7oMEzEd9Q=";

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
