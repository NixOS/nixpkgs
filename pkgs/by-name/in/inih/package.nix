{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "inih";
  version = "62";

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = "inih";
    rev = "r${finalAttrs.version}";
    hash = "sha256-jnMGOncnH+ffgtyNzA8tZPtxPCR/yq9jmPsJZE4BhXo=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Simple .INI file parser in C, good for embedded systems";
    homepage = "https://github.com/benhoyt/inih";
    changelog = "https://github.com/benhoyt/inih/releases/tag/r${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ TredwellGit ];
    platforms = lib.platforms.all;
  };
})
