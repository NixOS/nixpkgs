{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  keyutils,
  libgcc,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proton-pass-cli";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "protonpass";
    repo = "pass-cli";
    tag = finalAttrs.version;
    hash = "sha256-nVim5gVNhnGg0anLZAlD4zcKg7ft6pO+6CkVgdj1iTc=";
  };

  cargoHash = "";

  __structuredAttrs = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line interface for managing your Proton Pass vaults, items, and secrets";
    homepage = "https://github.com/protonpass/pass-cli";
    license = lib.licenses.gpl3Only;
    mainProgram = "pass-cli";
    maintainers = with lib.maintainers; [ delafthi ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
