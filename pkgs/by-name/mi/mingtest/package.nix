{
  stdenv,
  cmake,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation rec {
  name = "mingtest";
  version = "0.2.1";
  src = fetchFromGitHub {
    owner = "craflin";
    repo = "mingtest";
    rev = "refs/tags/${version}";
    hash = "sha256-buFr5w+3YJ2gJeQ8YTsFrUMU9hWq/iAJ6cW6ykvETfM=";
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
