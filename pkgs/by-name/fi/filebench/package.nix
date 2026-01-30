{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "filebench";
  version = "1.4.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/filebench/filebench-${finalAttrs.version}.tar.gz";
    sha256 = "13hmx67lsz367sn8lrvz1780mfczlbiz8v80gig9kpkpf009yksc";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
  ];

  meta = {
    description = "File system and storage benchmark that can generate both micro and macro workloads";
    homepage = "https://sourceforge.net/projects/filebench/";
    license = lib.licenses.cddl;
    maintainers = [ lib.maintainers.dezgeg ];
    platforms = lib.platforms.linux;
    mainProgram = "filebench";
  };
})
