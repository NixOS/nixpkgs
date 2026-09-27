{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miracl-core";
  version = "0-unstable-2026-06-09";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "miracl";
    repo = "core";
    rev = "a6df6733c1ad1ad0918306abd0c3983b4cd4a58c";
    hash = "sha256-Nc+UxmmNxZWHTm0WA+OYdqkQS+accIZGOaanqMg0C78=";
  };

  nativeBuildInputs = [ python3 ];

  strictDeps = true;

  # config64.py -> configure and build in one step.
  dontConfigure = true;

  # The upstream test programs link against many different curves, so any subset of curves would make the test suite unbuildable.
  # The full set is what makes a single static library generally useful downstream.

  buildPhase = ''
    runHook preBuild
    cd c
    python3 config64.py test
    runHook postBuild
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck

    # Upstream test programs print failure markers but exit `0` even when a sub-test fails
    # so their output should be checked regardless of the exit status.

    failRe='Failed|FAILED|FAILURE|INVALID|NOT verified|Error from'

    # `testmpin` prompts for a PIN several times. The registration and authentication must use the same PIN for the protocol to work.
    printf '1234\n%.0s' $(seq 1 32) > mpin-input.txt

    for t in testecc testeddsa testmpin testbls testnhs testdlthm testkyber; do
      if [ ! -x "./$t" ]; then
        echo "ERROR: expected upstream test program '$t' was not built" >&2
        exit 1          ### Checks the existance of the test executable
      fi
      echo "==== running $t"
      set +e
      if [ "$t" = testmpin ]; then
        "./$t" < mpin-input.txt > "$t.log" 2>&1   ### the M-PIN is fed
      else
        "./$t" > "$t.log" 2>&1
      fi
      status=$?
      set -e
      if [ "$status" -ne 0 ]; then
        cat "$t.log"
        echo "ERROR: $t exited with status $status" >&2
        exit 1
      fi
      if grep -Eq "$failRe" "$t.log"; then
        cat "$t.log"
        echo "ERROR: $t reported a failure (matched: $failRe)" >&2
        exit 1
      fi
    done

    runHook postCheck
  '';

  # Upstream's header names are generic (core.h, config_big.h, big_*.h) so they are gathered under `include/miracl/`.
  # The library is renamed from upstream's core.a so that -lmiracl-core links without ambiguity.

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/include/miracl
    cp core.a $out/lib/libmiracl-core.a
    cp *.h $out/include/miracl/

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Multi-language cryptographic library supporting elliptic curves, pairings, RSA and NIST post-quantum schemes";
    homepage = "https://github.com/miracl/core";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pauloaviana ];
    platforms = lib.platforms.unix;
    badPlatforms = [ lib.systems.inspect.patterns.is32bit ];
  };
})
