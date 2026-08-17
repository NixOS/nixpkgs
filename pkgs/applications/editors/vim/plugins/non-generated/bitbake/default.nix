{
  fetchFromGitHub,
  lib,
  vimUtils,
}:

let
  version = "6.0.2";
in
vimUtils.buildVimPlugin {
  pname = "bitbake";
  inherit version;

  src = fetchFromGitHub {
    owner = "openembedded";
    repo = "bitbake";
    tag = "yocto-${version}";
    hash = "sha256-Jho1X7udSvh413u8ueRqR8z1Q7E2qcotdkzl9azBu7g=";
  };

  sourceRoot = "source/contrib/vim";

  meta = {
    homepage = "https://github.com/openembedded/bitbake";
    license = lib.licenses.gpl2Only;
  };
}
