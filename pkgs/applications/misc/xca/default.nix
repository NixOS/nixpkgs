{ stdenv
, lib
, fetchFromGitHub
, wrapQtAppsHook
, cmake
, pkg-config
, openssl
, qtbase
, qttools
, sphinx
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xca";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "chris2511";
    repo = "xca";
    rev = "RELEASE.${finalAttrs.version}";
    hash = "sha256-Ty6j0Fl2smMGxp+1nnD3Fu83bn19gqtRKSA1wDgNZes=";
  };

  buildInputs = [ openssl qtbase ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    sphinx
    wrapQtAppsHook
  ];

  # Needed for qcollectiongenerator (see https://github.com/NixOS/nixpkgs/pull/92710)
  QT_PLUGIN_PATH = "${qtbase}/${qtbase.qtPluginPrefix}";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "X509 certificate generation tool, handling RSA, DSA and EC keys, certificate signing requests (PKCS#10) and CRLs";
    mainProgram = "xca";
    homepage = "https://hohnstaedt.de/xca/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ offline peterhoeg ];
    inherit (qtbase.meta) platforms;
  };
})
