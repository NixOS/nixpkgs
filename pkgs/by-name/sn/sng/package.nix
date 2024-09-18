{
  lib,
  fetchurl,
  libpng,
  netpbm,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sng";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/sng/sng-${finalAttrs.version}.tar.gz";
    hash = "sha256-EZxVhwwdG9xl996dvGKSnMsMMBwvt59332P11HfzRhk=";
  };

  buildInputs = [ libpng ];

  configureFlags = [ "--with-rgbtxt=${netpbm.out}/share/netpbm/misc/rgb.txt" ];

  strictDeps = true;

  meta = {
    homepage = "https://sng.sourceforge.net/";
    description = "Minilanguage designed to represent the entire contents of a PNG file in an editable form";
    license = lib.licenses.zlib;
    mainProgram = "sng";
    maintainers = with lib.maintainers; [ dezgeg ];
    platforms = lib.platforms.unix;
  };
})
