{
  fetchFromGitHub,
  cmake,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "forkunion";
  version = "2.3.1";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ashvardanian";
    repo = "ForkUnion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ikDhf5aDCjUJ94lOC0m1Z43q92vyzEfSNdSO25Irv1o=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    changelog = "https://github.com/ashvardanian/ForkUnion/releases/tag/${finalAttrs.src.tag}";
    description = "Lower-latency OpenMP-style minimalistic scoped thread-pool designed for 'Fork-Join' parallelism in Rust and C++, avoiding memory allocations, mutexes, CAS-primitives, and false-sharing on the hot path";
    homepage = "https://github.com/ashvardanian/ForkUnion";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
