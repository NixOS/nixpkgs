{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ptp-trace";
  version = "0.22";

  src = fetchFromGitHub {
    owner = "holoplot";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-HoaiV48Np33ti8BUUeUd0qNQK+x7xa1RHZPnf/Ms4gI=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-cCEtHCN3F7KjJM24Oko5+pkt51wDH5siLObwwwoWe2w=";

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "ptp-trace --version";
      version = "0.1.0"; # the application has version hardcoded to 0.1.0
    };
  };

  meta = {
    mainProgram = "ptp-trace";
    description = "Terminal application to trace PTP traffic";
    homepage = "https://github.com/holoplot/ptp-trace";
    license = lib.licenses.gpl2;
    maintainers = [
      lib.maintainers.dbalan
    ];
    platforms = lib.platforms.unix;
  };
})
