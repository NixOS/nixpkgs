{
  lib,
  rustPlatform,
  cacert,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bulletty";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "CrociDB";
    repo = "bulletty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZuNug06zL89D7EWh6UFLiT/Xs/bQOEKY/UiDdkU091M=";
  };

  patches = [
    # Add patch that disables rustfmt to prevent compile time crashes
    ./remove-rustfmt-exec.patch
  ];

  cargoHash = "sha256-fOuUBp5ij0ZqcRhhEIl3pAinsheIHF9VW9Uw3RB4pCI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  checkInputs = [ cacert ];

  env.OPENSSL_NO_VENDOR = true;

  # Upstream test binds a localhost TCP listener
  __darwinAllowLocalNetworking = true;
  sandboxProfile = ''
    (allow mach-lookup
     (global-name "com.apple.FSEvents")
     (global-name "com.apple.SystemConfiguration.configd"))
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal UI RSS/ATOM feed reader";
    homepage = "https://bulletty.croci.dev";
    changelog = "https://github.com/CrociDB/bulletty/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.FKouhai ];
    mainProgram = "bulletty";
  };
})
