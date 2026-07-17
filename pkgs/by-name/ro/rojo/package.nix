{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rojo";
  version = "7.7.0";

  src = fetchFromGitHub {
    owner = "rojo-rbx";
    repo = "rojo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2atNAiv51MNpxXdwvKSvtO1CGvQUOdUUOZszjAm3zi8=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-1xTvW3Ra6erYpjxgfp2m8qVMz6u99WCDv2VE/Xh2mFc=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # reqwest's native-tls-vendored feature flag uses vendored openssl. this disables that
  env.OPENSSL_NO_VENDOR = true;

  # tests flaky on darwin on hydra
  doCheck = !stdenv.hostPlatform.isDarwin;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/rojo";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/rojo-rbx/rojo/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Project management tool for Roblox";
    downloadPage = "https://github.com/rojo-rbx/rojo/releases/tag/v${finalAttrs.version}";
    homepage = "https://rojo.space";
    license = lib.licenses.mpl20;
    longDescription = ''
      Tool designed to enable Roblox developers to use professional-grade software engineering tools.
    '';
    mainProgram = "rojo";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
  };
})
