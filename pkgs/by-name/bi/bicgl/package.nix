{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libminc,
  bicpl,
  libGLU,
  libglut,
}:

stdenv.mkDerivation {
  pname = "bicgl";
  version = "1.3.60-unstable-2018-04-06";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "bicgl";
    rev = "61a035751c9244fcca1edf94d6566fa2a709ce90";
    sha256 = "0lzirdi1mf4yl8srq7vjn746sbydz7h0wjh7wy8gycy6hq04qrg4";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libminc
    bicpl
    libGLU
    libglut
  ];

  cmakeFlags = [
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    "-DBICPL_DIR=${bicpl}/lib"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "https://github.com/BIC-MNI/bicgl";
    description = "Brain Imaging Centre graphics library";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.hpndUc;
  };
}
