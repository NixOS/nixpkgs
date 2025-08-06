{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doctest";
  version = "2.4.12";

  src = fetchFromGitHub {
    owner = "doctest";
    repo = "doctest";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-Fxs1EWydhqN9whx+Cn4fnZ4fhCEQvFgL5e9TUiXlnq8=";
  };

  patches = [
    # Suppress unsafe buffer usage warnings with clang 16, which are treated as errors due to `-Werror`.
    # https://github.com//doctest/doctest/pull/768
    (fetchpatch {
      url = "https://github.com/doctest/doctest/commit/9336c9bd86e3fc2e0c36456cad8be3b4e8829a22.patch";
      hash = "sha256-ZFCVk5qvgfixRm7ZFr7hyNCSEvrT6nB01G/CBshq53o=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/doctest/doctest";
    description = "Fastest feature-rich C++11/14/17/20 single-header testing framework";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
