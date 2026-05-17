{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "small";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "alandefreitas";
    repo = "small";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+aPieFls2u2A57CKQz/q+ZqGjNyscDlWDryAp3VM1Lk=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "C++ small containers";
    homepage = "https://github.com/alandefreitas/small";
    license = lib.licenses.boost;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
