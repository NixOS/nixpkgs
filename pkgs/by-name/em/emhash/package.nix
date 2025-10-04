{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "emhash";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ktprime";
    repo = "emhash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dFj/QaGdTJYdcxKlS9tES6OHae8xPMnrG9ccRNM/hi8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # By default, it will try to build the benchmark suite,
    # but we only care about the headers copied by the install target.
    "-DWITH_BENCHMARKS=Off"
  ];

  passthru.update-script = nix-update-script { };

  meta = {
    homepage = "https://github.com/ktprime/emhash";
    changelog = "https://github.com/ktprime/emhash/releases/tag/v${finalAttrs.version}";
    description = "Fast and memory efficient c++ flat hash map/set";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ blenderfreaky ];
    platforms = lib.platforms.all;
  };
})
