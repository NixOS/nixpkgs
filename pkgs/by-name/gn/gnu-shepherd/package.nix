{
  stdenv,
  lib,
  fetchurl,
  guile,
  pkg-config,
  guile-fibers,
}:

stdenv.mkDerivation rec {
  pname = "gnu-shepherd";
<<<<<<< HEAD
  version = "1.0.9";

  src = fetchurl {
    url = "mirror://gnu/shepherd/shepherd-${version}.tar.gz";
    hash = "sha256-5IjFhchBjfbo9HbcqBtykQ8zfJzTYI+0Z95SYABAANY=";
=======
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://gnu/shepherd/shepherd-${version}.tar.gz";
    hash = "sha256-MlqbdYHug6FRFd+/vMJHyetRD3UlSaI/OukSqOxydZc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  configureFlags = [ "--localstatedir=/" ];

  buildInputs = [
    guile
    guile-fibers
  ];
  nativeBuildInputs = [ pkg-config ];

<<<<<<< HEAD
  meta = {
    homepage = "https://www.gnu.org/software/shepherd/";
    description = "Service manager that looks after the herd of system services";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kloenk ];
=======
  meta = with lib; {
    homepage = "https://www.gnu.org/software/shepherd/";
    description = "Service manager that looks after the herd of system services";
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ kloenk ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
