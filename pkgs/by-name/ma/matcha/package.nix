{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  pcsclite,
  stdenv,
  apple-sdk_15,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "matcha";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "floatpane";
    repo = "matcha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bvy7og6om+Mqn4J0GrtIx8VQQXUiy8Y7Kueyfj5FWWQ=";
  };

  vendorHash = "sha256-SH7zP5+3R82mMx9vHY8QbPUkLr29pwbIbiV55UUQu+M=";
  proxyVendor = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ pcsclite ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  subPackages = [ "." ];

  env.CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.date=1970-01-01T00:00:00Z"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Beautiful and functional email client for the terminal";
    homepage = "https://matcha.email";
    changelog = "https://github.com/floatpane/matcha/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "matcha";
    maintainers = with lib.maintainers; [ andrinoff ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})
