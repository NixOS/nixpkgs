{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sshpass";
  version = "1.10";

  src = fetchurl {
    url = "mirror://sourceforge/sshpass/sshpass-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-rREGwgPLtWGFyjutjGzK/KO0BkaWGU2oefgcjXvf7to=";
  };

  meta = {
    homepage = "https://sourceforge.net/projects/sshpass/";
    description = "Non-interactive ssh password auth";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.madjar ];
    platforms = lib.platforms.unix;
    mainProgram = "sshpass";
  };
})
