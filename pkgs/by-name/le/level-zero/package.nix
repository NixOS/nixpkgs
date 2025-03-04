{
  lib,
  addDriverRunpath,
  cmake,
  fetchFromGitHub,
  intel-compute-runtime,
  openvino,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "level-zero";
  version = "1.20.2";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "level-zero";
    tag = "v${version}";
    hash = "sha256-IqnEjlKBB3nx2rOTBG+rrJ078z8+kkg52hFV2+5lJV0=";
  };

  nativeBuildInputs = [
    cmake
    addDriverRunpath
  ];

  postFixup = ''
    addDriverRunpath $out/lib/libze_loader.so
  '';

  passthru.tests = {
    inherit intel-compute-runtime openvino;
  };

  meta = with lib; {
    description = "oneAPI Level Zero Specification Headers and Loader";
    homepage = "https://github.com/oneapi-src/level-zero";
    changelog = "https://github.com/oneapi-src/level-zero/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.ziguana ];
  };
}
