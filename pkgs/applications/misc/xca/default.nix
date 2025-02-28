{
  stdenv,
  lib,
  fetchFromGitHub,
  wrapQtAppsHook,
  cmake,
  pkg-config,
  openssl,
  qtbase,
  qttools,
  sphinx,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xca";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "chris2511";
    repo = "xca";
    rev = "RELEASE.${finalAttrs.version}";
    hash = "sha256-2TqqHTutG+5YU2mJNTS3pvtEqV7qKVB+j/dipdmEkIk=";
  };

  buildInputs = [
    openssl
    qtbase
  ];

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

  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    mv "$out/xca.app" "$out/Applications/xca.app"
  '';

  meta = with lib; {
    description = "X509 certificate generation tool, handling RSA, DSA and EC keys, certificate signing requests (PKCS#10) and CRLs";
    mainProgram = "xca";
    homepage = "https://hohnstaedt.de/xca/";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      offline
      peterhoeg
    ];
    inherit (qtbase.meta) platforms;
  };
})
