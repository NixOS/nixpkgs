{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "inferno";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KB9E4kqi85reDJnjb2PKgOsBo9opTuPVUW4nDrJIMmU=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-AA1Bm70W2gAL2IohQwY0wcLNq6AOzQ3oqVRzzyeRyxA=";

  # skip flaky tests
  checkFlags = [
    "--skip=collapse::dtrace::tests::test_collapse_multi_dtrace"
    "--skip=collapse::dtrace::tests::test_collapse_multi_dtrace_simple"
    "--skip=collapse::perf::tests::test_collapse_multi_perf"
    "--skip=collapse::perf::tests::test_collapse_multi_perf_simple"
    "--skip=flamegraph_base_symbol"
    "--skip=flamegraph_multiple_base_symbol"
  ];

  meta = with lib; {
    description = "Port of parts of the flamegraph toolkit to Rust";
    homepage = "https://github.com/jonhoo/inferno";
    changelog = "https://github.com/jonhoo/inferno/blob/v${version}/CHANGELOG.md";
    license = licenses.cddl;
    maintainers = with maintainers; [ figsoda ];
  };
}
