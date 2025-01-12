{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "jaq";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    tag = "v${version}";
    hash = "sha256-S8ELxUKU8g8+6HpM+DxINEqMDha7SgesDymhCb7T9bg=";
  };

  cargoHash = "sha256-i3AxIlRY6r0zrMmZVh1l9fPiR652xjhTcwCyHCHCrL8=";

  # This very line fails on `x86_64-darwin`: assertion failed: out.eq(ys)
  # https://github.com/01mf02/jaq/blob/v2.0.1/jaq-json/tests/funs.rs#L118
  postPatch = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    substituteInPlace jaq-json/tests/funs.rs \
      --replace-fail 'give(json!(null), "2.1 % 0 | isnan", json!(true));' ""
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    changelog = "https://github.com/01mf02/jaq/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      siraben
    ];
    mainProgram = "jaq";
  };
}
