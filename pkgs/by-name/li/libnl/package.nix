{
  stdenv,
  file,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  flex,
  pkg-config,
  doxygen,
  graphviz,
  mscgen,
  asciidoc,
  sourceHighlight,
  pythonSupport ? false,
  swig ? null,
  python ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnl";
  version = "3.12.0";

  src = fetchFromGitHub {
    repo = "libnl";
    owner = "thom311";
    rev = "libnl${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-K77WamOf+/3PNXe/hI+OYg0EBgBqvDfNDamXYXcK7P8=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
  ]
  ++ lib.optional pythonSupport "py";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
    file
    doxygen
    graphviz
    mscgen
    asciidoc
    sourceHighlight
  ]
  ++ lib.optional pythonSupport swig;

  postBuild = lib.optionalString pythonSupport ''
    cd python
    ${python.pythonOnBuildForHost.interpreter} setup.py install --prefix=../pythonlib
    cd -
  '';

  postFixup = lib.optionalString pythonSupport ''
    mv "pythonlib/" "$py"
  '';

  passthru = {
    inherit pythonSupport;
  };

  meta = {
    homepage = "http://www.infradead.org/~tgr/libnl/";
    description = "Linux Netlink interface library suite";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.linux;
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "libnl_project" finalAttrs.version;
  };
})
