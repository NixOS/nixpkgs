{
  lib,
  stdenv,
  cmake,
  eigen,
  fetchFromGitHub,
  gz-cmake,
  gz-utils,
  python3Packages,
  ruby,
  swig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-math";
  version = "8.2.0";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-math";
    tag = "gz-math${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    hash = "sha256-UpwgQrQrFuBe/ls9HtZy+UgO8b2ObHLCmCS6epEwOPo=";
  };

  nativeBuildInputs = [
    cmake
    gz-cmake
  ];

  buildInputs = [
    gz-utils
    eigen
    ruby
    swig
  ];

  doCheck = true;

  nativeCheckInputs = [
    python3Packages.pybind11
  ];

  meta = {
    description = "Math classes and functions for robot applications";
    homepage = "https://gazebosim.org/home";
    downloadPage = "https://github.com/gazebosim/gz-math";
    changelog = "https://github.com/gazebosim/gz-math/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
