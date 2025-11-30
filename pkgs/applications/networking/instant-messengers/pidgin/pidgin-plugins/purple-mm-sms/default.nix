{
  lib,
  stdenv,
  glibmm,
  pidgin,
  pkg-config,
  modemmanager,
  fetchFromGitLab,
}:

stdenv.mkDerivation rec {
  pname = "purple-mm-sms";
  version = "0.1.7";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "purple-mm-sms";
    rev = "v${version}";
    sha256 = "0917gjig35hmi6isqb62vhxd3lkc2nwdn13ym2gvzgcjfgjzjajr";
  };

  makeFlags = [
    "DATA_ROOT_DIR_PURPLE=$(out)/share"
    "PLUGIN_DIR_PURPLE=$(out)/lib/purple-2"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glibmm
    pidgin
    modemmanager
  ];

  meta = with lib; {
    homepage = "https://source.puri.sm/Librem5/purple-mm-sms";
    description = "Libpurple plugin for sending and receiving SMS via Modemmanager";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
