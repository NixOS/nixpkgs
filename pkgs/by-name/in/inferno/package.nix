{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "inferno";
  version = "0.12.8";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "inferno";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IRL7hHXZlJiYw4dea0gjxVTgpSwxeAZBCCqkMMkukRo=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-RB9XUURf+Eb2c3JcmqCmmM776FuNenn6Mj2zjo1X/Tw=";

  # skip flaky tests
  checkFlags = [
    "--skip=collapse::dtrace::tests::test_collapse_multi_dtrace"
    "--skip=collapse::dtrace::tests::test_collapse_multi_dtrace_simple"
    "--skip=collapse::perf::tests::test_collapse_multi_perf"
    "--skip=collapse::perf::tests::test_collapse_multi_perf_simple"
    "--skip=flamegraph_base_symbol"
    "--skip=flamegraph_multiple_base_symbol"
  ];

  meta = {
    description = "Port of parts of the flamegraph toolkit to Rust";
    homepage = "https://github.com/jonhoo/inferno";
    changelog = "https://github.com/jonhoo/inferno/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.cddl;
    maintainers = [ lib.maintainers.matthiasbeyer ];
  };
})
