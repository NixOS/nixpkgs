{
  lib,
  stdenv,
  fetchFromGitHub,
  dbus,
  cmake,
  pkg-config,
  bash-completion,
  gsl,
  popt,
  clightd,
  systemd,
  libconfig,
  libmodule,
  withGeoclue ? true,
  geoclue2,
  withUpower ? true,
  upower,
}:

stdenv.mkDerivation rec {
  pname = "clight";
  version = "4.11";

  src = fetchFromGitHub {
    owner = "FedeDP";
    repo = "Clight";
    rev = version;
    sha256 = "sha256-Fu38HRP83Yn2jsq9xnCWOXNlV/0hJKD1/cOOp3EV45Q=";
  };

  nativeBuildInputs = [
    dbus
    cmake
    pkg-config
    bash-completion
  ];

  buildInputs =
    [
      gsl
      popt
      upower
      clightd
      systemd
      geoclue2
      libconfig
      libmodule
    ]
    ++ lib.optional withGeoclue geoclue2
    ++ lib.optional withUpower upower;

  cmakeFlags = [
    "-DSESSION_BUS_DIR=${placeholder "out"}/share/dbus-1/services"
    "-DBASH_COMPLETIONS_DIR=${placeholder "out"}/share/bash-completions/completions"
    "-DZSH_COMPLETIONS_DIR=${placeholder "out"}/share/zsh/site-functions"
  ];

  meta = with lib; {
    description = "C daemon that turns your webcam into a light sensor";
    homepage = "https://github.com/FedeDP/Clight";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [
      eadwu
    ];
    mainProgram = "clight";
  };
}
