# tools/nixception-hook.nix
#
# A setup hook that starts a nixception remote-execution server before the
# build phase and stops it afterwards.  Consumers add it to nativeBuildInputs:
#
#   nativeBuildInputs = [ nixceptionHook ];
#
# See ./nixception-setup-hook.sh for details.

{
  lib,
  stdenv,
  nixception,
  nixceptionHook,
  buildbox,
  wait4x,
  moreutils,
  makeSetupHook,
  runCommandLocal,
  shellcheck,
}:
let
  # ── Pure packaging check ──────────────────────────────────────────────────
  # No recursive-nix, no running server: just assert the installed hook script
  # is well-formed.  Runs in ordinary CI.
  packaging-check =
    runCommandLocal "nixception-hook-test"
      {
        nativeBuildInputs = [ shellcheck ];
        installedHook = "${nixceptionHook}/nix-support/setup-hook";
      }
      ''
        # Every @token@ substitution must be resolved (no literal @…@ left)
        if grep -oE '@[a-zA-Z0-9_]+@' "$installedHook"; then
          echo "FAIL: unresolved substitution token(s) remain in the setup hook"; exit 1
        fi

        # Shellcheck
        # SC2148: no shebang. Setup hooks are sourced by stdenv, not executed.
        if ! shellcheck --shell=bash --exclude=SC2148 "$installedHook"; then
          echo "FAIL: shellcheck reported problems"; exit 1
        fi

        touch $out
      '';

  # ── Runtime smoke test (recursive-nix gated) ─────────────────────────────
  # Actually adds the hook to a build, lets it start the nixception server,
  # routes one trivial C compile through it via `recc` and checks result.
  smoke-test = stdenv.mkDerivation {
    name = "nixception-hook-smoke-test";
    dontUnpack = true;
    nativeBuildInputs = [
      nixceptionHook
      buildbox
    ];
    requiredSystemFeatures = [ "recursive-nix" ];

    # Point recc at the server the hook starts (recc otherwise defaults to
    # localhost:8085 for CAS / action cache).
    RECC_INSTANCE = "main";
    RECC_SERVER = "127.0.0.1:50051";
    RECC_VERBOSE = 1;

    buildPhase = ''
      runHook preBuild

      cat > hello.c <<'EOF'
      #include <stdio.h>
      int main(void) { printf("nixception smoke ok\n"); return 0; }
      EOF

      echo "compiling hello.c through recc -> nixception ..."
      # recc runs linking locally, so split compilation in two
      recc "$CC" -c -O2 -o hello.o hello.c
      recc "$CC" -o hello hello.o

      test -x hello || { echo "FAIL: recc did not produce an executable"; exit 1; }
      output="$(./hello)"
      test "$output" = "nixception smoke ok" \
        || { echo "FAIL: unexpected program output: $output"; exit 1; }
      echo "ok: recc-built binary runs and prints the expected line"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin"
      cp hello "$out/bin/"
      runHook postInstall
    '';

    meta = {
      description = "Runtime smoke test: one C compile routed through nixceptionHook + recc";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ layus ];
      platforms = lib.platforms.linux;
    };
  };
in
makeSetupHook {
  name = "nixception-hook";

  substitutions = {
    nixception = "${nixception}";
    wait4x = "${wait4x}";
    moreutils = "${moreutils}";
  };

  passthru.tests = { inherit packaging-check smoke-test; };
} ./nixception-setup-hook.sh
