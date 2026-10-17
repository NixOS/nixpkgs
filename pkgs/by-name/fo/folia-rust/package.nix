{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "folia";
  version = "0.0.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "proycon";
    repo = "folia-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dtlA2vWrqCTVinTWLQdDFrHp2fNI0sT+CzQ2f6mPmMU=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock

    # Avoid undefined behavior from uninitialized libc::rusage
    substituteInPlace src/bin/foliabenchmarkr.rs \
      --replace-fail 'mem::MaybeUninit::uninit().assume_init()' \
                     'mem::MaybeUninit::zeroed().assume_init()'

    substituteInPlace src/bin/folialintr.rs src/bin/foliabenchmarkr.rs \
      --replace-fail '.version("0.0.1")' \
                     '.version(env!("CARGO_PKG_VERSION"))'
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    description = "High-performance library for handling the FoLiA XML format (Format for Linguistic Annotation)";
    homepage = "https://proycon.github.io/folia";
    license = lib.licenses.gpl3Plus;
    mainProgram = "folialintr";
    maintainers = with lib.maintainers; [ aaravrav ];
    platforms = lib.platforms.linux;
    knownVulnerabilities = [
      "RUSTSEC-2026-0194: quick-xml quadratic run time when checking a start tag for duplicate attribute names"
      "RUSTSEC-2026-0195: quick-xml unbounded namespace-declaration allocation (memory-exhaustion DoS)"
    ];
  };
})
