{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  re2c,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcaption";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "szatmary";
    repo = "libcaption";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9tszEKR30GHoGQ3DE9ejU3yOdtDiZwSZHiIJUPLgOdU=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ re2c ];

  meta = with lib; {
    description = "Free open-source CEA608 / CEA708 closed-caption encoder/decoder";
    homepage = "https://github.com/szatmary/libcaption";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pschmitt ];
  };
})
