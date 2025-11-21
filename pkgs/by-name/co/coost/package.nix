{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  openssl,
  gitUpdater,
  withCurl ? true,
  withOpenSSL ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coost";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "idealvin";
    repo = "coost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HbMenAL/UWsqQ1o7cMeWfwXkLh4GxIKV7iuZQD3hDA8=";
  };

  postPatch = ''
    substituteInPlace cmake/coost.pc.in \
      --replace-fail '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@ \
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optional withCurl curl ++ lib.optional withOpenSSL openssl;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ]
  ++ lib.optional withCurl "-DWITH_LIBCURL=ON"
  ++ lib.optional withOpenSSL "-DWITH_OPENSSL=ON";

  outputs = [
    "out"
    "dev"
  ];
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    allowedVersions = "^[0-9]";
  };

  meta = {
    description = "Tiny boost library in C++11";
    homepage = "https://github.com/idealvin/coost";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sigmanificient ];
    platforms = lib.platforms.unix;
  };
})
