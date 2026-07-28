{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lhasa";
  version = "0.6.0";

  src = fetchurl {
    url = "https://soulsphere.org/projects/lhasa/lhasa-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-mEAVQ2f3Pp2cMZb5RKEhq005jYTpIcj+j8qKkxJ0rtc=";
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
    mainProgram = "lha";
    platforms = lib.platforms.unix;
  };
})
