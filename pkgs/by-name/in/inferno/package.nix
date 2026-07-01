{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "inferno";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "inferno";
    tag = "v${finalAttrs.version}";
    hash = "sha256-maqyxntCm8F8B14+26+ASJNl7JL3Pk+xzwgA2f8r4zc=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-0Zn3KS8Qo39yR+WUxj68eYt9jnDwpf4QUBGBqZPqFIU=";

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
