{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, postgresql, libgcrypt, pam, libxcrypt }:

stdenv.mkDerivation rec {
  pname = "pam_pgsql";
  version = "unstable-2020-05-05";

  src = fetchFromGitHub {
    owner = "pam-pgsql";
    repo = "pam-pgsql";
    rev = "f9fd1e1a0daf754e6764a31db5cbec6f9fc02b3d";
    sha256 = "1bvddrwyk1479wibyayzc24h62qzfnlbk9qvdhb31yw9yn17gp6k";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libgcrypt pam postgresql libxcrypt ];

  meta = with lib; {
    description = "Support to authenticate against PostgreSQL for PAM-enabled appliations";
    homepage = "https://github.com/pam-pgsql/pam-pgsql";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
