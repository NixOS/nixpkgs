{
  lib,
  fetchFromGitHub,
  rustPlatform,
  rustc,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pentect";
  version = "0.0.16";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "EdamAme-x";
    repo = "pentect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rmULftKFwMdVlZAQsGI8a37PpnYNjjCvB5DmRo1ydro=";
  };

  cargoHash = "sha256-pO2ZoyGOsfikyznFw9y3O2gR9oxZkWxN26Pkau9C+E8=";

  cargoBuildFlags = [
    "-p"
    "pentect-cli"
  ];
  cargoTestFlags = [
    "-p"
    "pentect-cli"
  ];

  postPatch = lib.optionalString (stdenv.isx86_64 && lib.versionOlder rustc.llvm.version "22") ''
    # LLVM 21 has an incompatible signature for the AVX-512 VNNI intrinsic used by
    # rten-gemm. Disable that optional dispatch path and retain its AVX2 fallback.
    substituteInPlace "$cargoDepsCopy/source-registry-0/rten-gemm-0.24.0/src/i8dot.rs" \
      --replace-fail 'if !is_x86_feature_detected!("avx512vnni") {' 'if true {' \
      --replace-fail '_mm512_dpbusd_epi32(acc.0, a.0, b.0).into()' 'unreachable!("AVX-512 VNNI is disabled for LLVM 21")'
  '';

  preCheck = ''
    export HOME="$TMPDIR/home"
    export XDG_CACHE_HOME="$TMPDIR/cache"
    export XDG_CONFIG_HOME="$TMPDIR/config"
    export XDG_DATA_HOME="$TMPDIR/data"
    export XDG_STATE_HOME="$TMPDIR/state"
    mkdir -p "$HOME" "$XDG_CACHE_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"
  '';

  postInstall = ''
    cat > "$out/bin/.pentect-managed-install.json" <<'JSON'
    {"version":1,"manager":"nix","update":"nix profile upgrade pentect","uninstall":"nix profile remove pentect"}
    JSON
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    test "$($out/bin/pentect version)" = "pentect ${finalAttrs.version}"
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local secret masking boundary for AI agents";
    homepage = "https://github.com/EdamAme-x/pentect";
    changelog = "https://github.com/EdamAme-x/pentect/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ edamame_x ];
    mainProgram = "pentect";
  };
})
