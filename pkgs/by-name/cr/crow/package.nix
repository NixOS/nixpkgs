{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  catch2_3,
  asio,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crow";
  version = "1.2.1.2";

  src = fetchFromGitHub {
    owner = "CrowCpp";
    repo = "Crow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iQ2owNry4LOmMxyO5L7O7XZB5vwUf+ZuZL76hZ6FThk=";
  };

  patches = [
    ./cpm.patch
  ];

  propagatedBuildInputs = [ asio ];
  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "CROW_BUILD_EXAMPLES" false)
  ];

  doCheck = true;
  nativeCheckInputs = [
    python3
  ];
  checkInputs = [
    catch2_3
  ];

  meta = {
    description = "Fast and Easy to use microframework for the web";
    homepage = "https://crowcpp.org/";
    maintainers = with lib.maintainers; [ l33tname ];
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
  };
})
