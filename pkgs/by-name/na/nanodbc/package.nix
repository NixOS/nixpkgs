{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  unixodbc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nanodbc";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "nanodbc";
    repo = "nanodbc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GUC7JlI5Bp5javoTaWXsMdE3B0N9xiaHz/PlIrFkMXM=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ unixodbc ];

  nativeCheckInputs = [ ctestCheckHook ];
  doCheck = true;
  ctestFlags = [
    "-R"
    "^utility_tests$"
  ];

  cmakeFlags =
    lib.optionals stdenv.cc.isClang [ (lib.cmakeBool "NANODBC_FORCE_LIBCXX" false) ]
    ++ (
      if (stdenv.hostPlatform.isStatic) then
        [ "-DBUILD_STATIC_LIBS=ON" ]
      else
        [ "-DBUILD_SHARED_LIBS=ON" ]
    );

  meta = {
    homepage = "https://github.com/nanodbc/nanodbc";
    changelog = "https://github.com/nanodbc/nanodbc/raw/v${finalAttrs.version}/CHANGELOG.md";
    description = "Small C++ wrapper for the native C ODBC API";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bzizou ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
