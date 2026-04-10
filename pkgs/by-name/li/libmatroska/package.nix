{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libebml,
  nix-update-script,
  pkg-config,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmatroska";
  version = "1.7.2";

  outputs = [
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "Matroska-Org";
    repo = "libmatroska";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-FedoJxUsRgKQn41PZGBaeF0O29PVQEOK20LsNMK3xHo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [ libebml ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=YES" ];

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "release-(.*)"
      ];
    };
  };

  meta = {
    description = "Library to parse Matroska files";
    homepage = "https://matroska.org/";
    changelog = "https://github.com/Matroska-Org/libmatroska/blob/${finalAttrs.src.rev}/NEWS.md";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ getchoo ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "libmatroska" ];
  };
})
