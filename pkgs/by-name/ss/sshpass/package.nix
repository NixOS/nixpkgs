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

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/sshpass/";
    description = "Non-interactive ssh password auth";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.madjar ];
    platforms = platforms.unix;
    mainProgram = "sshpass";
  };
}
