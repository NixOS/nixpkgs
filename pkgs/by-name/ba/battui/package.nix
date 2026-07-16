{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "battui";
  version = "0.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "siliconwitch";
    repo = "battui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4ckx9A8g/chCkFb3TCz8wAkxhnj/aU9DOjZyn8/eg2Q=";
  };

  vendorHash = "sha256-L/ASdcuE6eeuaKsL9CJioY7UP1F+KxGZ0MU/OzMx+NQ=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    install -Dm644 contrib/systemd/battui-log.service \
      $out/lib/systemd/user/battui-log.service

    substituteInPlace $out/lib/systemd/user/battui-log.service \
      --replace-fail /usr/local/bin/battui $out/bin/battui
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiny battery monitor for the terminal";
    homepage = "https://github.com/siliconwitch/battui";
    changelog = "https://github.com/siliconwitch/battui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "battui";
    maintainers = with lib.maintainers; [ siliconwitch ];
    platforms = lib.platforms.linux;
  };
})
