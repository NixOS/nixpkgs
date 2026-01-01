{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "sshpass";
  version = "1.10";

  src = fetchurl {
    url = "mirror://sourceforge/sshpass/sshpass-${version}.tar.gz";
    sha256 = "sha256-rREGwgPLtWGFyjutjGzK/KO0BkaWGU2oefgcjXvf7to=";
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://sourceforge.net/projects/sshpass/";
    description = "Non-interactive ssh password auth";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.madjar ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    homepage = "https://sourceforge.net/projects/sshpass/";
    description = "Non-interactive ssh password auth";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.madjar ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "sshpass";
  };
}
