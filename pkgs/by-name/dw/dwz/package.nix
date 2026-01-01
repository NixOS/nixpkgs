{
  lib,
  stdenv,
  fetchurl,
  elfutils,
<<<<<<< HEAD
  xxHash,
  dejagnu,
  gdb,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation rec {
  pname = "dwz";
<<<<<<< HEAD
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
=======
  version = "0.14";

  src = fetchurl {
    url = "https://www.sourceware.org/ftp/${pname}/releases/${pname}-${version}.tar.gz";
    sha256 = "07qdvzfk4mvbqj5z3aff7vc195dxqn1mi27w2dzs1w2zhymnw01k";
  };

  nativeBuildInputs = [ elfutils ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://sourceware.org/dwz/";
    description = "DWARF optimization and duplicate removal tool";
    mainProgram = "dwz";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jbcrail ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
