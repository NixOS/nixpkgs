{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pikpaktui";
  version = "0.0.56";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Bengerthelorf";
    repo = "pikpaktui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LUOVfjNutjtXk4omjSoJNA+b2sACnXZsRNlUB7oWD60=";
  };

  cargoHash = "sha256-lTLZm+gPH4qYfZSsZ4YXcz5Zd8U7JYX+b9U2wwm08ew=";

  nativeBuildInputs = [ pkg-config ];

  env.OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ];

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "TUI and CLI client for PikPak cloud storage";
    homepage = "https://app.snaix.homes/pikpaktui/";
    downloadPage = "https://github.com/Bengerthelorf/pikpaktui/releases";
    license = lib.licenses.asl20;
    mainProgram = "pikpaktui";
    maintainers = with lib.maintainers; [ chillcicada ];
  };
})
