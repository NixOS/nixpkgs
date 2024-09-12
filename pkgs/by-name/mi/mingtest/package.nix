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
    rev = "refs/tags/${version}";
    hash = "sha256-Iy2KvFCFk+uoztTVxTY7HMdc5GI4gSGqGmbJePJ5CO8=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "include(CDeploy)" "" \
      --replace-fail "install_deploy_export()" ""
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Minimalistic C++ unit test framework";
    homepage = "https://github.com/craflin/mingtest";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lutzberger ];
    platforms = lib.platforms.linux;
  };

}
