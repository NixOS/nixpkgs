{ lib, stdenv, fetchFromGitHub
, dbus, cmake, pkg-config, bash-completion
, gsl, popt, clightd, systemd, libconfig, libmodule
, withGeoclue ? true, geoclue2
, withUpower ? true, upower }:

stdenv.mkDerivation rec {
  pname = "clight";
  version = "4.10";

  src = fetchFromGitHub {
    owner = "FedeDP";
    repo = "Clight";
    rev = version;
    sha256 = "sha256-IAoz4f4XrX8bgesWL4yLK6m5F+c75WNIMFgKBj+W61Q=";
  };

  nativeBuildInputs = [
    dbus
    cmake
    pkg-config
    bash-completion
  ];

  buildInputs = with lib; [
    gsl
    popt
    upower
    clightd
    systemd
    geoclue2
    libconfig
    libmodule
  ] ++ optional withGeoclue geoclue2
    ++ optional withUpower upower;

  cmakeFlags = [
    "-DSESSION_BUS_DIR=${placeholder "out"}/share/dbus-1/services"
    "-DBASH_COMPLETIONS_DIR=${placeholder "out"}/share/bash-completions/completions"
    "-DZSH_COMPLETIONS_DIR=${placeholder "out"}/share/zsh/site-functions"
  ];

  meta = with lib; {
    description = "A C daemon that turns your webcam into a light sensor";
    homepage = "https://github.com/FedeDP/Clight";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
