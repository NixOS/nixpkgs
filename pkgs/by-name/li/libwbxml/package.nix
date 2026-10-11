{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  expat,
  check,
  perl,
  pkg-config,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwbxml";
  version = "0.11.10";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "libwbxml";
    repo = "libwbxml";
    tag = "libwbxml-${finalAttrs.version}";
    hash = "sha256-yy8+CyNKXuttCmxRxH/XptIloDklto4f5Zg0vnwnneY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ expat ];

  nativeCheckInputs = [ perl ];
  checkInputs = [ check ];
  doCheck = true;

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "libwbxml2" ];
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://github.com/libwbxml/libwbxml";
    changelog = "https://github.com/libwbxml/libwbxml/releases/tag/${finalAttrs.src.tag}";
    description = "WBXML Library (aka libwbxml) contains a library and its associated tools to Parse, Encode and Handle WBXML documents";
    maintainers = with lib.maintainers; [ mh ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "libwbxml2" ];
    license = lib.licenses.lgpl21Plus;
  };
})
