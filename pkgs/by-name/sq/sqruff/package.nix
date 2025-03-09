{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
  rust-jemalloc-sys,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "sqruff";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "quarylabs";
    repo = "sqruff";
    rev = "refs/tags/v${version}";
    hash = "sha256-Vlre3D1ydDqFdysf5no2rW2V2U/BimhCeV1vWZ2JPSM=";
  };

  cargoHash = "sha256-WqkHZcA4FBm8zubAnDrJGH+fgLVIxsNNm3B+mdj5Sxw=";

  buildInputs = [
    rust-jemalloc-sys
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.CoreServices ];

  # Patch the tests to find the binary
  postPatch = ''
    substituteInPlace crates/cli/tests/ui.rs \
      --replace-fail \
      'sqruff_path.push(format!("../../target/{}/sqruff", profile));' \
      'sqruff_path.push(format!("../../target/${stdenv.hostPlatform.rust.cargoShortTarget}/{}/sqruff", profile));'
  '';

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast SQL formatter/linter";
    homepage = "https://github.com/quarylabs/sqruff";
    changelog = "https://github.com/quarylabs/sqruff/releases/tag/${version}";
    license = lib.licenses.asl20;
    mainProgram = "sqruff";
    maintainers = with lib.maintainers; [ hasnep ];
  };
}
