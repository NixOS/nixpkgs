{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ptp-trace";
  version = "0.22";

  src = fetchFromGitHub {
    owner = "holoplot";
    repo = "ptp-trace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HoaiV48Np33ti8BUUeUd0qNQK+x7xa1RHZPnf/Ms4gI=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-cCEtHCN3F7KjJM24Oko5+pkt51wDH5siLObwwwoWe2w=";

  postPatch = ''
    # upstream uses git-describe for version, falls back to stale cargo PKGVERSION
    substituteInPlace build.rs \
      --replace-fail 'env::var("CARGO_PKG_VERSION").unwrap_or_else(|_| "0.1.0".to_string())' '"v${finalAttrs.version}".to_string()' \
      --replace-fail 'chrono::Utc::now()
            .format("%Y-%m-%d %H:%M:%S UTC")
            .to_string()' '"1970-01-01 00:00:00 UTC".to_string()'
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "ptp-trace";
    description = "Terminal application to trace PTP traffic";
    homepage = "https://github.com/holoplot/ptp-trace";
    changelog = "https://github.com/holoplot/ptp-trace/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = [
      lib.maintainers.dbalan
    ];
    platforms = lib.platforms.unix;
  };
})
