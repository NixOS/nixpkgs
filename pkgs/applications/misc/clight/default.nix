{ lib, stdenv, fetchFromGitHub
, dbus, cmake, pkg-config, bash-completion
, gsl, popt, clightd, systemd, libconfig, libmodule
, withGeoclue ? true, geoclue2
, withUpower ? true, upower }:

stdenv.mkDerivation rec {
  pname = "clight";
  version = "4.9";

  src = fetchFromGitHub {
    owner = "FedeDP";
    repo = "Clight";
    rev = version;
    sha256 = "sha256-m1oKjyy7fMK6mIf5FRuWCbfAM8qlHXRR/rwHsCZADiY=";
  };

  # dbus-1.pc has datadir=/etc
  SESSION_BUS_DIR = "${placeholder "out"}/share/dbus-1/services";

  postPatch = ''
    sed -i "s@/usr@$out@" CMakeLists.txt
    sed -i "s@/etc@$out\0@" CMakeLists.txt
    sed -i "s@pkg_get_variable(SESSION_BUS_DIR.*@set(SESSION_BUS_DIR $SESSION_BUS_DIR)@" CMakeLists.txt
  '';

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
    # bash-completion.pc completionsdir=${bash-completion.out}
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
