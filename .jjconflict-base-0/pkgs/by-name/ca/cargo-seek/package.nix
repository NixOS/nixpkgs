{
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-seek";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tareqimbasher";
    repo = "cargo-seek";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SDVAi4h+/ebGX+8M66Oyd0LfQn+J7/QhDW97ZBdoN14=";
  };

  cargoHash = "sha256-DyXRbtvCJte7mCQKusipeikr981vMHPEVYcGSwVI5Kg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ writableTmpDirAsHomeHook ];
  # We cannot use `versionCheckHook` here since access to the $HOME directory is required.
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/cargo-seek --version | grep "${finalAttrs.version}"
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal user interface for searching, adding and installing cargo crates";
    homepage = "https://github.com/tareqimbasher/cargo-seek";
    changelog = "https://github.com/tareqimbasher/cargo-seek/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qwqawawow ];
    mainProgram = "cargo-seek";
  };
})
