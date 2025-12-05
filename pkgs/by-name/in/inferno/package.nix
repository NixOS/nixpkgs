{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "inferno";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "inferno";
    tag = "v${version}";
    hash = "sha256-8c3JRPUvuo1uQ22vgzgEPXoNSRnUKciEff13QrN3WHI=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-Oj0thDPa1LPBhxp45JA6prIXuHpBpHcw59rMwPQavQ0=";

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
    maintainers = [ ];
  };
}
