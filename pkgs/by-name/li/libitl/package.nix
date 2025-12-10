{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libitl";
  version = "0.1.8-unstable-2024-05-26";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "arabeyes-org";
    repo = "ITL";
    rev = "07de1851722d0818d1f981df234e1b585eb60e05";
    hash = "sha256-bhejnA7FfuopR27heliaE/vNd1Rqvnjj3n/vkjmimAw=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Islamic Tools and Libraries (ITL)";
    longDescription = ''
      The Islamic Tools and Libraries (ITL) project provides
      a fully featured library for performing common Islamic calculations.
    '';
    homepage = "https://www.arabeyes.org/ITL";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ amyipdev ];
  };
})
