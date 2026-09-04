{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  nlohmann_json,
}:
let
  src = fetchFromGitHub {
    owner = "layus";
    repo = "nixception";
    rev = "v0.5.0";
    fetchSubmodules = true;
    hash = "sha256-tjIhrGhsrmBTJ1OD/Fxao7z9+wn2JCE1S8ggYQIH9Ek=";
  };

  # Nixception relies on a runner derivation that must be built from its own
  # tree. We build it here and pass it below.
  runner = stdenv.mkDerivation {
    name = "nixception-runner";
    src = "${src}/tools/runner";
    buildInputs = [ nlohmann_json ];
    meta = with lib; {
      description = "C++ runner for nixception REAPI action derivations";
      platforms = platforms.linux;
    };
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixception";
  version = "0.5.0";
  __structuredAttrs = true;
  inherit src;
  cargoHash = "sha256-Nqv1dwh//Ph6CUIK73n3/NVuoSt0RGjpxKL0mjG0stc=";

  # Version override (no git repo).
  env.NIXCEPTION_VERSION = "v${finalAttrs.version}";

  # Wire the runner into the binary.
  env.NIXCEPTION_RUNNER_OUT = "${runner.out}";
  env.NIXCEPTION_RUNNER_DRV = "${
    # Plain `runner.drvPath` trips restricted eval in CI.
    # We "only" need the .drv itself, not the full input closure.
    builtins.unsafeDiscardOutputDependency runner.drvPath
  }";

  # For convenience.
  passthru.runner = runner;

  meta = with lib; {
    description = "Remote execution API endpoint that builds every action as a Nix derivation";
    homepage = "https://github.com/layus/nixception";
    # The nixception sources are Apache-2.0 (based on the last Apache-licensed
    # NativeLink commit); the binary also statically links the GPL-3.0
    # nix-compat crate from tvix.
    license = with licenses; [
      asl20
      gpl3Only
    ];
    maintainers = with maintainers; [ layus ];
    platforms = platforms.linux;
  };
})
