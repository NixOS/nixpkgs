{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  python3,
  gtest,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "numcpp";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "dpilger26";
    repo = "NumCpp";
    tag = "Version_${finalAttrs.version}";
    hash = "sha256-8ghHTRneLeiFgzF9zHFjFu46qopc3l2Svku1H06XQTw=";
  };

  patches = [ ./pytest-CMakeLists.patch ];

  nativeCheckInputs = [
    gtest
    python3
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ];

  cmakeFlags = lib.optionals finalAttrs.finalPackage.doCheck [
    "-DBUILD_TESTS=ON"
    "-DBUILD_MULTIPLE_TEST=ON"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isStatic;

  postInstall = ''
    substituteInPlace $out/share/NumCpp/cmake/NumCppConfig.cmake \
      --replace-fail "\''${PACKAGE_PREFIX_DIR}/" ""
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = {
    description = "Templatized Header Only C++ Implementation of the Python NumPy Library";
    homepage = "https://github.com/dpilger26/NumCpp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ spalf ];
    platforms = lib.platforms.unix;
  };
})
