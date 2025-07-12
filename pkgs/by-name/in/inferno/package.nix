{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "inferno";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "inferno";
    rev = "v${version}";
    hash = "sha256-D72rkTnUgLJRHFEDoUwQDLQJAPGyqmxhf6hmNJGUl+U=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Gc31yyspU7RYDQDpVvq+UhMnE7t4HQ65fSGu9eDN6C0=";

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
    changelog = "https://github.com/jonhoo/inferno/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.cddl;
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
