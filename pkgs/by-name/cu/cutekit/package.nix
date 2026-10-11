{
  lib,
  llvmPackages_22,
  fetchFromCodeberg,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cutekit";
  version = "0.12.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "cute-engineering";
    repo = "cutekit";
    rev = finalAttrs.version;
    hash = "sha256-Qbt+xd/g1ca3Ufc8dp6ouYxf57VUuwS//h3nptXKv4M=";
  };

  patches = [ ./os-release-fallback.patch ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    dataclasses-json
    graphviz
    markdown
    tomli-w
  ];

  # cutekit resolves its toolchain (clang++, llvm-ar, clang-scan-deps,
  # ninja, pkg-config) from PATH at run time, as upstream intends.
  nativeCheckInputs = [ llvmPackages_22.clangUseLLVM ] ++ (with python3Packages; [ pytestCheckHook ]);

  pytestFlags = [
    "-p"
    "no:cacheprovider"
    "tests"
  ];
  # These create projects under tests/ in the source tree, which is
  # read-only in the Nix sandbox.
  disabledTestPaths = [ "tests/test_init.py" ];

  # Upstream pins graphviz~=0.20.1; nixpkgs ships 0.21, which is
  # backwards-compatible with its API.
  dontCheckRuntimeDeps = true;

  meta = {
    description = "A package manager and build system for low-level projects";
    homepage = "https://codeberg.org/cute-engineering/cutekit";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ yajo ];
  };
})
