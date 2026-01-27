{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  sphinxHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jrl-cmakemodules";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "jrl-umi3218";
    repo = "jrl-cmakemodules";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TUewcxvBGYF3WpqkiWvZzmbyXyaM+UqzHLVsaUJdC0w=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    cmake
    sphinxHook
  ];

  sphinxRoot = "../.docs";

  postPatch = ''
    patchShebangs _unittests/run_unit_tests.sh
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    pushd ../_unittests
    ./run_unit_tests.sh
    cmake -P test_pkg-config.cmake

    rm -rf build install
    popd

    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CMake utility toolbox";
    homepage = "https://github.com/jrl-umi3218/jrl-cmakemodules";
    changelog = "https://github.com/jrl-umi3218/jrl-cmakemodules/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.all;
  };
})
