{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "lhasa";
  version = "0.4.0";

  src = fetchurl {
    url = "https://soulsphere.org/projects/lhasa/lhasa-${version}.tar.gz";
    sha256 = "sha256-p/yIPDBMUIVi+5P6MHpMNCsMiG/MJl8ouS3Aw5IgxbM=";
  };

  meta = {
    description = "Free Software replacement for the Unix LHA tool";
    longDescription = ''
      Lhasa is a Free Software replacement for the Unix LHA tool, for
      decompressing .lzh (LHA / LHarc) and .lzs (LArc) archives. The backend for
      the tool is a library, so that it can be reused for other purposes.
    '';
    license = lib.licenses.isc;
    homepage = "http://fragglet.github.io/lhasa";
    maintainers = [ lib.maintainers.sander ];
    mainProgram = "lha";
    platforms = lib.platforms.unix;
  };
}
