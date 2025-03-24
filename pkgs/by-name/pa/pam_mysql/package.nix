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

stdenv.mkDerivation rec {
  pname = "pam_mysql";
  version = "1.0.0-beta2";

  src = fetchFromGitHub {
    owner = "NigelCunningham";
    repo = "pam-MySQL";
    rev = version;
    sha256 = "07acf0hbhkd0kg49gnj4nb5ilnv3v4xx3dsggvzvjg8gi3cjmsap";
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

  meta = with lib; {
    description = "PAM authentication module against a MySQL database";
    homepage = "https://github.com/NigelCunningham/pam-MySQL";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ netali ];
  };
}
