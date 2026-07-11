{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libhydrogen";
  version = "0-unstable-2025-04-06";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "libhydrogen";
    rev = "bbca575b62510bfdc6dd927a4bfa7df4a51cb846";
    hash = "sha256-sLOE3oR53hmvRqIPD5PU9Q04TFqw2KuWT1OQBA/KdRc=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ pkg-config ];
  enableParallelBuilding = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "INCLUDE_INSTALL_DIR=${placeholder "dev"}/include"
    "LIBRARY_INSTALL_DIR=${placeholder "out"}/lib"
    "PKGCONFIG_INSTALL_DIR=${placeholder "dev"}/lib/pkgconfig"
    "lib"
  ];

  checkTarget = "test";

  postInstall = ''
    mkdir -p "$dev/lib/pkgconfig"
    cat > "$dev/lib/pkgconfig/libhydrogen.pc" <<EOF
    Name: libhydrogen
    Description: Lightweight cryptographic library
    Version: ${finalAttrs.version}
    Libs: -L$out/lib -lhydrogen
    Cflags: -I$dev/include
    EOF
  '';

  doCheck = true;

  preCheck = ''
    export LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Lightweight, secure, easy-to-use crypto library suitable for constrained environments";
    homepage = "https://github.com/jedisct1/libhydrogen";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.tanya1866 ];
    pkgConfigModules = [ "libhydrogen" ];
    platforms = lib.platforms.all;
  };
})
