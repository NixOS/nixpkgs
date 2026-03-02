{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  adaptivecpp,
  onetbb,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "onedpl";
  version = "2022.11.1";

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "oneDPL";
    tag = "oneDPL-${finalAttrs.version}-release";
    hash = "sha256-NfyV34mdKfCxlU+l6ETKWcC9MwvVEgwcBedtLe6WCV4=";
  };

  nativeBuildInputs = [
    cmake
    adaptivecpp
  ];

  buildInputs = [
    onetbb
    adaptivecpp
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_COMPILER" "acpp")
    (lib.cmakeFeature "ONEDPL_BACKEND" "dpcpp")
  ];

  env = {
    ACPP_TARGETS = lib.strings.join ";" [ "generic" ];
  };

  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex 'oneDPL-(.*)-release'" ];
  };

  meta = {
    changelog = "https://github.com/uxlfoundation/oneDPL/releases/tag/oneDPL-${finalAttrs.version}-release";
    description = "oneAPI DPC++ Library (oneDPL)";
    homepage = "http://uxlfoundation.github.io/oneDPL";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
