{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  python3Packages,
  wrapGAppsHook3,
  atk,
  dbus,
  evemu,
  frame,
  gdk-pixbuf,
  gobject-introspection,
  grail,
  gtk3,
  xorg,
  pango,
  xorgserver,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geis";
  version = "2.2.17";

  src = fetchurl {
    url = "https://launchpad.net/geis/trunk/${finalAttrs.version}/+download/geis-${finalAttrs.version}.tar.xz";
    hash = "sha256-imD1aDhSCUA4kE5pDSPMWpCpgPxS2mfw8oiQuqJccOs=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error=misleading-indentation -Wno-error=pointer-compare";

  hardeningDisable = [ "format" ];

  pythonPath = with python3Packages; [ pygobject3 ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    python3Packages.wrapPython
    gobject-introspection
    validatePkgConfig
  ];

  buildInputs = [
    atk
    dbus
    evemu
    frame
    gdk-pixbuf
    grail
    gtk3
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXtst
    pango
    python3Packages.python
    xorgserver
  ];

  prePatch = ''
    substituteInPlace python/geis/geis_v2.py --replace-fail \
      "ctypes.util.find_library(\"geis\")" "'$out/lib/libgeis.so'"
    substituteInPlace config.aux/py-compile \
      --replace-fail "import sys, os, py_compile, imp" "import sys, os, py_compile, importlib" \
      --replace-fail "imp." "importlib." \
      --replace-fail "hasattr(imp" "hasattr(importlib"
  '';

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(--set PYTHONPATH "$program_PYTHONPATH")
  '';

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  meta = {
    description = "Library for input gesture recognition";
    homepage = "https://launchpad.net/geis";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    pkgConfigModules = [ "libgeis" ];
  };
})
