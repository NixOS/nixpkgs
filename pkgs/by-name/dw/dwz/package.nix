{
  lib,
  stdenv,
  fetchurl,
  elfutils,
  xxhash,
  dejagnu,
  gdb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dwz";
  version = "0.17";

  src = fetchurl {
    url = "https://www.sourceware.org/ftp/dwz/releases/dwz-${finalAttrs.version}.tar.gz";
    hash = "sha256-hJVMWmi/whF4x+BQx/BCmrJ80wLO4maPSRy4uUq2XVU=";
  };

  postPatch = ''
    patchShebangs --build testsuite
  '';

  nativeBuildInputs = [ elfutils ];

  buildInputs = [
    xxhash
    elfutils
  ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  doCheck = true;

  nativeCheckInputs = [
    dejagnu
    gdb
  ];

  strictDeps = true;

  meta = {
    homepage = "https://sourceware.org/dwz/";
    description = "DWARF optimization and duplicate removal tool";
    mainProgram = "dwz";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jbcrail ];
    platforms = [ lib.systems.inspect.patterns.isElf ];
  };
})
