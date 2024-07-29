{
  stdenv,
  cmake,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation rec {
  name = "mingtest";
  version = "0.1.9";
  src = fetchFromGitHub {
    owner = "craflin";
    repo = "mingtest";
    rev = "ref/tags/${version}";
    hash = "sha256-PSJ1+PtPR59qO/msCTS3o2ShjYkhO4h0Mtn0XY+KluQ=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "include(CDeploy)" "" \
      --replace-fail "install_deploy_export()" ""
  '';

  buildInputs = [
    cmake
  ];

  meta = {
    description = "A minimalistic C++ unit test framework";
    homepage = "https://github.com/craflin/mingtest";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lutzberger ];
    platforms = lib.platforms.linux;
  };


}
