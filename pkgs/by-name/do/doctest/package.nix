{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "doctest";
  version = "2.4.11";

  src = fetchFromGitHub {
    owner = "doctest";
    repo = "doctest";
    rev = "v${version}";
    sha256 = "sha256-hotO6QVpPn8unYTaQHFgi40A3oLUd++I3aTe293e4Aw=";
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

  meta = with lib; {
    homepage = "https://github.com/doctest/doctest";
    description = "Fastest feature-rich C++11/14/17/20 single-header testing framework";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ davidtwco ];
  };
}
