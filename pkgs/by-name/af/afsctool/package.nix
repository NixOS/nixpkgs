{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  git,
  zlib,
  sparsehash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "afsctool";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "RJVB";
    repo = "afsctool";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    gitConfigFile = builtins.toFile "gitconfig" ''
      [url "https://github.com/"]
      insteadOf = "git://github.com/"
    '';
    hash = "sha256-irWPQnnV5mHZS7pw9PAWp6MO/3MahKaOIZCr6awcwEg=";
  };

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    git
  ];
  buildInputs = [
    zlib
    sparsehash
  ];

  meta = {
    description = "Utility that allows end-users to leverage HFS+/APFS compression";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ viraptor ];
    platforms = lib.platforms.darwin;
    homepage = "https://github.com/RJVB/afsctool";
  };
})
