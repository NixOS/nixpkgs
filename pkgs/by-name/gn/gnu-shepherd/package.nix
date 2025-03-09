{ stdenv, lib, fetchurl, guile, pkg-config, guile-fibers }:

stdenv.mkDerivation rec {
  pname = "gnu-shepherd";
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://gnu/shepherd/shepherd-${version}.tar.gz";
    hash = "sha256-30usBLSwR2+o+e0TgpKsLMVLQwS17v2FntSJLU+ZJL8=";
  };

  configureFlags = [ "--localstatedir=/" ];

  buildInputs = [ guile guile-fibers ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/shepherd/";
    description = "Service manager that looks after the herd of system services";
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ kloenk ];
  };
}
