{
  lib,
  fetchCrate,
  cargo,
  clippy,
  makeBinaryWrapper,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "simit";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchCrate {
    pname = "simit";
    inherit (finalAttrs) version;
    hash = "sha256-NJou2R+K41JxMqXIbYwiHeoLuhflbN99ksVZgZTkb9I=";
  };

  cargoHash = "sha256-1BqrVbaa/Calo2T8ktIyYcmS765khQdqkabe7gv9cKw=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/simit" \
      --suffix PATH : ${
        lib.makeBinPath [
          cargo
          clippy
          git
        ]
      }
  '';

  nativeCheckInputs = [
    clippy
    git
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstallCheck = ''
    runtimeCheckDir=$(mktemp -d)
    mkdir -p "$runtimeCheckDir/src" "$runtimeCheckDir/home"
    cat > "$runtimeCheckDir/Cargo.toml" <<'EOF'
    [package]
    name = "runtime-check"
    version = "0.1.0"
    edition = "2021"
    EOF
    touch "$runtimeCheckDir/src/lib.rs"
    (
      cd "$runtimeCheckDir"
      env -i HOME="$runtimeCheckDir/home" PATH="" \
        "$out/bin/simit" commit --dry-run patch > plan.txt
      grep -F 'package runtime-check: 0.1.0 -> 0.1.1' plan.txt
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Semver-aware git commit helper for Rust projects";
    homepage = "https://codeberg.org/caniko/simit";
    changelog = "https://codeberg.org/caniko/simit/src/tag/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caniko ];
    mainProgram = "simit";
  };
})
