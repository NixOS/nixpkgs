{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  netpbm,
  valgrind,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netpbm2osbadgeicons";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "OPNA2608";
    repo = "netpbm2osbadgeicons";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qbkw4jF5/sB9VB59trrNqvojYhUitfN34a0QXYA2v10=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    netpbm
  ];

  nativeCheckInputs = [
    ctestCheckHook
    valgrind
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "NETPBM2OSBADGEICONS_WERROR" true)
    (lib.strings.cmakeBool "NETPBM2OSBADGEICONS_TEST_VALGRIND" true)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = {
    description = "Convert Netpbm images to OS-BADGE-ICONS information";
    homepage = "https://github.com/OPNA2608/netpbm2osbadgeicons";
    license = lib.licenses.gpl3Plus;
    mainProgram = "netpbm2osbadgeicons";
    maintainers = [ lib.maintainers.OPNA2608 ];
    platforms = lib.platforms.all;
  };
})
