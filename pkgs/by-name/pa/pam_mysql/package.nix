{
  lib,
  nixosTests,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pam,
  pkg-config,
  libmysqlclient,
  mariadb,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pam_mysql";
  version = "1.0.0-beta2";

  src = fetchFromGitHub {
    owner = "NigelCunningham";
    repo = "pam-MySQL";
    rev = finalAttrs.version;
    hash = "sha256-V+kq2YgPPbn/fk+30TvZY1say7JE2pfIm6BNuCBwTB0=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];
  buildInputs = [
    pam
    libmysqlclient
    mariadb
    libxcrypt
  ];

  passthru.tests = {
    inherit (nixosTests) auth-mysql;
  };

  meta = {
    description = "PAM authentication module against a MySQL database";
    homepage = "https://github.com/NigelCunningham/pam-MySQL";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ netali ];
  };
})
