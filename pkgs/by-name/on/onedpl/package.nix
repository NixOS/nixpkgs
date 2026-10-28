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
  version = "2022.11.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "oneDPL";
    tag = "oneDPL-${finalAttrs.version}-release";
    hash = "sha256-NfyV34mdKfCxlU+l6ETKWcC9MwvVEgwcBedtLe6WCV4=";
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
      "'oneDPL-(.*)-release'"
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
