{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neargye-semver";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Neargye";
    repo = "semver";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-ANH6GjtEbxozCVev25xO9agr2LkJb7uDLVTmuL0bZ7M=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  doCheck = true;

  # Install headers
  postInstall = ''
    mkdir -p $out/include
    cp -r $src/include/* $out/include/
  '';

  meta = {
    description = "C++17 header-only dependency-free versioning library complying with Semantic Versioning 2.0.0";
    homepage = "https://github.com/Neargye/semver";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ phodina ];
  };
})
