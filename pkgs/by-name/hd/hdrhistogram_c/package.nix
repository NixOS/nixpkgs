{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  nix-update-script,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hdrhistogram_c";
  version = "0.11.9";

  src = fetchFromGitHub {
    owner = "HdrHistogram";
    repo = "HdrHistogram_c";
    tag = finalAttrs.version;
    hash = "sha256-9Xp+gPqJpB7xZr5dzyc9Via9gxG9q/EriCx3cm++0kU=";
  };

  buildInputs = [ zlib ];
  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
  };

  meta = {
    description = "C port or High Dynamic Range (HDR) Histogram";
    homepage = "https://github.com/HdrHistogram/HdrHistogram_c";
    changelog = "https://github.com/HdrHistogram/HdrHistogram_c/releases/tag/${finalAttrs.version}";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ jherland ];
    pkgConfigModules = [ "hdr_histogram" ];
  };
})
