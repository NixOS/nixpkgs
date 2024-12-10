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
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "level-zero";
    rev = "refs/tags/v${version}";
    hash = "sha256-ep9RYHnqmOEqfdFtYzOZnv0aWu4TA8JMyWOj0E2uSYk=";
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
