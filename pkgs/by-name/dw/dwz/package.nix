{
  lib,
  stdenv,
  fetchurl,
  elfutils,
  xxHash,
  dejagnu,
  gdb,
}:

stdenv.mkDerivation rec {
  pname = "dwz";
  version = "0.16";

  src = fetchurl {
    url = "https://www.sourceware.org/ftp/dwz/releases/dwz-${version}.tar.gz";
    hash = "sha256-R1hT4bSebtjMLQqQnHpPwcxXHrzPxmJ4/UM0Lb4n1Q4=";
  };

  postPatch = ''
    patchShebangs --build testsuite
  '';

  nativeBuildInputs = [ elfutils ];

  buildInputs = [
    xxHash
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
}
