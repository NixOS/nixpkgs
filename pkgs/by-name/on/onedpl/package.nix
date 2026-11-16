{
  lib,
  intelLlvmStdenv,
  fetchFromGitHub,
  cmake,
  onetbb,
  nix-update-script,
}:
intelLlvmStdenv.mkDerivation (finalAttrs: {
  pname = "onedpl";
  version = "2022.14.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "oneDPL";
    tag = "oneDPL-release-${finalAttrs.version}";
    hash = "sha256-0MvUSxT1DYXAGJ5JzdYLPm9B8vg3DKTY50bpMp4ysaU=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    onetbb
  ];

  cmakeFlags = [
    (lib.cmakeFeature "ONEDPL_BACKEND" "dpcpp")
  ];

  # Build times for the tests are excessive
  # and to be truly meaningful, they'd require a GPU
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "oneDPL-release-(\\d+\\.\\d+\\.\\d+)"
    ];
  };

  meta = {
    description = "oneAPI DPC++ Library (oneDPL)";
    homepage = "http://uxlfoundation.github.io/oneDPL";
    changelog = "https://github.com/uxlfoundation/oneDPL/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arunoruto ];
    platforms = lib.platforms.all;
  };
})
