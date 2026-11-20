{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  keyutils,
  libgcc,
  makeBinaryWrapper,
  openssl,
  pkg-config,
  sqlcipher,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proton-pass-cli";
  version = "2.7.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "protonpass";
    repo = "pass-cli";
    tag = finalAttrs.version;
    hash = "sha256-ZhpWbw6vM3j7s5fcYzJ7lC9vI74lcjTSWycXwvidaS0=";
  };

  cargoHash = "sha256-kih+CY2l89FTaMy/HPar1FxYfi6WKTg6S+90gHH5wSI=";

  # pass-uniffi-bindgen generates the Python bindings via maturin; its source
  # directory is not published in the GitHub repo, so it can't be a member
  postPatch = ''
    sed -i '/uniffi-bindgen/d' Cargo.toml
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlcipher
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    keyutils
    libgcc
  ];

  postFixup = ''
    wrapProgram $out/bin/pass-cli --set PROTON_PASS_NO_UPDATE_CHECK 1
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line interface for managing your Proton Pass vaults, items, and secrets";
    homepage = "https://github.com/protonpass/pass-cli";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pass-cli";
    maintainers = with lib.maintainers; [ delafthi ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
