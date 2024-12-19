{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  asio,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crow";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "crowcpp";
    repo = "crow";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fokj+KiS6frPVOoOvETxW3ue95kCcYhdhOlN3efzBd4=";
  };

  propagatedBuildInputs = [ asio ];
  nativeBuildInputs = [
    asio
    cmake
    python3
  ];

  cmakeFlags = [
    (lib.cmakeBool "CROW_BUILD_EXAMPLES" false)
  ];

  doCheck = true;

  meta = {
    description = "A Fast and Easy to use microframework for the web";
    homepage = "https://crowcpp.org/";
    maintainers = with lib.maintainers; [ l33tname ];
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
  };
})
