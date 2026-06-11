{
  fetchFromGitHub,
  cmake,
  forkunion,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stringzilla";
  version = "4.6.1";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ashvardanian";
    repo = "stringzilla";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yAxHOcxS4YYX0lvKwUExIBFBM5RDyFgeW9QA0WZBthA=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "-Werror;" ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    forkunion
  ];

  cmakeFlags = [
    (lib.cmakeBool "STRINGZILLA_INSTALL" true)
    (lib.cmakeBool "STRINGZILLA_BUILD_TEST" true)
  ];

  meta = {
    changelog = "https://github.com/ashvardanian/StringZilla/releases/tag/${finalAttrs.src.tag}";
    description = "SIMD-accelerated string search, sort, hashes, fingerprints, & edit distances";
    homepage = "https://github.com/ashvardanian/stringzilla";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      aciceri
      dotlambda
    ];
  };
})
