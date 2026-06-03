{
  lib,
  buildGoLatestModule,
  fetchFromGitHub,
  pkg-config,
  pcsclite,
  stdenv,
  apple-sdk_15,
  nix-update-script,
  versionCheckHook,
}:

buildGoLatestModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "matcha";
  version = "0.40.1";

  src = fetchFromGitHub {
    owner = "floatpane";
    repo = "matcha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4GbuiFFHQ14O+S2TtWiP1UWg3h6J9Cys6A8k5+0Ww/I=";
  };

  vendorHash = "sha256-TFc7e7gNtFNiCJHARngWSBKGqGhH7PiX48VkU9kD9Bs=";
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
