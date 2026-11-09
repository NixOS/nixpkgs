{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  gopass,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "gopass-hibp";
  version = "1.17.4";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-hibp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IJE/3Mi6tmxhbaxM09QgzvGmJ0FN6f7ciNeu99Ej4Fo=";
  };

  vendorHash = "sha256-O3lcvqkLHvByXyWDdspnUyvk41c2iJX3mFMQpFi1ThI=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/gopass-hibp \
      --prefix PATH : "${gopass.wrapperPath}"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
    gopass
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  preVersionCheck = ''
    gopass setup --name "user" --email "user@localhost"
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Gopass haveibeenpwnd.com integration";
    homepage = "https://github.com/gopasspw/gopass-hibp";
    changelog = "https://github.com/gopasspw/gopass-hibp/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "gopass-hibp";
  };
})
