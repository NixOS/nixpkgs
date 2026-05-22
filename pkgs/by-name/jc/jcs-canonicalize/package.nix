{
  lib,
  rustPlatform,
  fetchFromGitHub,
  runCommand,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jcs-canonicalize";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "arcanesys";
    repo = "jcs-canonicalize";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cqgjnx519cjGgTdamkzpWw+QWsiZOoiFDp4f3l2e4cw=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  cargoHash = "sha256-yPYBBSQm87WdK8Wf1VNYzBVR2yET6hvhcnYd1qDRQek=";

  passthru.tests = {
    basic =
      runCommand "jcs-canonicalize-test"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          # Key sorting: input keys reordered to lexicographic.
          actual=$(echo '{"b":2,"a":1}' | jcs-canonicalize)
          expected='{"a":1,"b":2}'
          if [ "$actual" != "$expected" ]; then
            echo "FAIL: key sorting"
            echo "  expected: $expected"
            echo "  got:      $actual"
            exit 1
          fi

          # Idempotence: canonicalizing canonical output yields same bytes.
          canonical=$(echo '{"x":[3,1,2]}' | jcs-canonicalize)
          re_canonical=$(echo "$canonical" | jcs-canonicalize)
          if [ "$canonical" != "$re_canonical" ]; then
            echo "FAIL: canonicalization is not idempotent"
            echo "  first:  $canonical"
            echo "  second: $re_canonical"
            exit 1
          fi

          # Invalid JSON exits non-zero.
          if echo 'not json' | jcs-canonicalize 2>/dev/null; then
            echo "FAIL: invalid JSON should exit non-zero"
            exit 1
          fi

          touch $out
        '';
  };

  meta = {
    description = "RFC 8785 JSON canonicalizer with SHA-256-over-canonical-bytes helper";
    longDescription = ''
      A CLI tool and Rust library that produces RFC 8785 canonical JSON: the
      same input value yields the same byte sequence regardless of key order,
      whitespace, or number formatting. That deterministic property is what
      lets cryptographic signatures over JSON verify reliably across
      implementations and across time.

      The library exposes `canonicalize` (string in, JCS string out) and
      `sha256_jcs_hex` (any Serialize value in, lowercase-hex SHA-256 over
      canonical bytes out). The CLI reads JSON from stdin and writes
      canonical JSON to stdout.

      Tested against the cyberphone/json-canonicalization reference corpus
      plus a golden-file drift test so consumers can rely on the byte
      sequence not changing across releases.
    '';
    homepage = "https://github.com/arcanesys/jcs-canonicalize";
    changelog = "https://github.com/arcanesys/jcs-canonicalize/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ abstracts33d ];
    mainProgram = "jcs-canonicalize";
    platforms = lib.platforms.unix;
  };
})
