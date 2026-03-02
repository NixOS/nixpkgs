#TODO@deliciouslytyped The tool seems to unnecessarily force mutable access for the debugedit `-l` feature
{
  fetchgit,
  fetchpatch,
  lib,
  stdenv,
  autoreconfHook,
  pkg-config,
  elfutils,
  xxHash,
  help2man,
  util-linux,
  cpio,
  gdb,
  dwz,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "debugedit";
  version = "5.2";

  src = fetchgit {
    url = "git://sourceware.org/git/debugedit.git";
    tag = "debugedit-${finalAttrs.version}";
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

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    help2man
  ];

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

  preBuild = ''
    patchShebangs scripts/find-debuginfo.in
  '';

  doCheck = true;

  meta = {
    description = "Provides programs and scripts for creating debuginfo and source file distributions, collect build-ids and rewrite source paths in DWARF data for debugging, tracing and profiling";
    homepage = "https://sourceware.org/debugedit/";
    license = lib.licenses.gpl3Plus;
    platforms = [ lib.systems.inspect.patterns.isElf ];
    maintainers = with lib.maintainers; [ deliciouslytyped ];
  };
})
