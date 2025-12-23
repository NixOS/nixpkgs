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
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://gnu/shepherd/shepherd-${version}.tar.gz";
    hash = "sha256-MlqbdYHug6FRFd+/vMJHyetRD3UlSaI/OukSqOxydZc=";
  };

  configureFlags = [ "--localstatedir=/" ];

  buildInputs = [
    guile
    guile-fibers
  ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    homepage = "https://www.gnu.org/software/shepherd/";
    description = "Service manager that looks after the herd of system services";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kloenk ];
  };
}
