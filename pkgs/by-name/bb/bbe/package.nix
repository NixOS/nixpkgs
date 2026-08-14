{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bbe";
  version = "0.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/bbe-/${finalAttrs.version}/bbe-${finalAttrs.version}.tar.gz";
    sha256 = "1nyxdqi4425sffjrylh7gl57lrssyk4018afb7mvrnd6fmbszbms";
  };

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [
    "out"
    "doc"
  ];

  meta = {
    description = "Sed-like editor for binary files";
    homepage = "https://bbe-.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.hhm ];
    mainProgram = "bbe";
  };
})
