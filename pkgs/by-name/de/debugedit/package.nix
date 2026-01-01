#TODO@deliciouslytyped The tool seems to unnecessarily force mutable access for the debugedit `-l` feature
{
  fetchgit,
<<<<<<< HEAD
  fetchpatch,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  lib,
  stdenv,
  autoreconfHook,
  pkg-config,
  elfutils,
<<<<<<< HEAD
  xxHash,
  help2man,
  util-linux,
  cpio,
  gdb,
  dwz,
}:
stdenv.mkDerivation rec {
  pname = "debugedit";
  version = "5.2";

  src = fetchgit {
    url = "git://sourceware.org/git/debugedit.git";
    tag = "debugedit-${version}";
    hash = "sha256-6SOw5t9Hnb9Picx18LwqLwaPieueO6mXl8/vGnU+81E=";
  };

  patches = [
    # fix: No build ID note found in ...
    # caused by gcc not configured to produce build-id by default
    (fetchpatch {
      url = "https://sourceware.org/git/?p=debugedit.git;a=commitdiff_plain;h=c011f478dca2c89d52958a8999b99663d14db85d";
      hash = "sha256-fOjXKA3U1YM+ZMieLhWiXdJj79IJ+iFNH0x+Asn/EMY=";
    })
  ];
=======
  help2man,
  util-linux,
}:
stdenv.mkDerivation rec {
  pname = "debugedit";
  version = "5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    help2man
  ];
<<<<<<< HEAD

  buildInputs = [
    elfutils
    xxHash
  ];

  nativeCheckInputs = [
    util-linux # Tests use `rev`
    cpio
    gdb
    dwz
  ];
=======
  buildInputs = [ elfutils ];
  nativeCheckInputs = [ util-linux ]; # Tests use `rev`

  src = fetchgit {
    url = "git://sourceware.org/git/debugedit.git";
    rev = "debugedit-${version}";
    sha256 = "VTZ7ybQT3DfKIfK0lH+JiehCJyJ+qpQ0bAn1/f+Pscs=";
  };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  preBuild = ''
    patchShebangs scripts/find-debuginfo.in
  '';

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "Provides programs and scripts for creating debuginfo and source file distributions, collect build-ids and rewrite source paths in DWARF data for debugging, tracing and profiling";
    homepage = "https://sourceware.org/debugedit/";
    license = lib.licenses.gpl3Plus;
    platforms = [ lib.systems.inspect.patterns.isElf ];
    maintainers = with lib.maintainers; [ deliciouslytyped ];
=======
  meta = with lib; {
    description = "Provides programs and scripts for creating debuginfo and source file distributions, collect build-ids and rewrite source paths in DWARF data for debugging, tracing and profiling";
    homepage = "https://sourceware.org/debugedit/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ deliciouslytyped ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
