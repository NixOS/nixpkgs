{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cereal";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "USCiLab";
    repo = "cereal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NwyUVeqXxfdyuDevjum6r8LyNtHa0eJ+4IFd3hLkiEE=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2020-11105.patch";
      url = "https://github.com/USCiLab/cereal/commit/f27c12d491955c94583512603bf32c4568f20929.patch";
      hash = "sha256-CIkbJ7bAN0MXBhTXQdoQKXUmY60/wQvsdn99FaWt31w=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DJUST_INSTALL_CEREAL=yes" ];

  meta = {
    homepage = "https://uscilab.github.io/cereal/";
    description = "Header-only C++11 serialization library";
    changelog = "https://github.com/USCiLab/cereal/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
