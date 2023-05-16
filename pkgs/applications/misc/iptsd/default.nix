{ lib
, stdenv
, fetchFromGitHub
, cmake
, meson
, ninja
, pkg-config
, cli11
, eigen
<<<<<<< HEAD
, hidrd
, inih
, microsoft-gsl
=======
, fmt
, hidrd
, inih
, microsoft_gsl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, spdlog
, systemd
}:

stdenv.mkDerivation rec {
  pname = "iptsd";
<<<<<<< HEAD
  version = "1.3.2";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-iVxxlblwrZ4SPbVR0kIG+ePExk4qT6gExgvHS1Ksp6A=";
=======
    hash = "sha256-8RE93pIg5fVAYOOq8zHlWy0uTxep7hrJlowPu48beTs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    meson
    ninja
    pkg-config
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    cli11
    eigen
<<<<<<< HEAD
    hidrd
    inih
    microsoft-gsl
=======
    fmt
    hidrd
    inih
    microsoft_gsl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    spdlog
    systemd
  ];

  # Original installs udev rules and service config into global paths
  postPatch = ''
    substituteInPlace etc/meson.build \
      --replace "install_dir: unitdir" "install_dir: '$out/etc/systemd/system'" \
      --replace "install_dir: rulesdir" "install_dir: '$out/etc/udev/rules.d'"
    substituteInPlace etc/udev/50-iptsd.rules.in \
      --replace "/bin/systemd-escape" "${systemd}/bin/systemd-escape"
  '';

  mesonFlags = [
    "-Dservice_manager=systemd"
    "-Dsample_config=false"
    "-Ddebug_tools="
    "-Db_lto=false"  # plugin needed to handle lto object -> undefined reference to ...
  ];

  meta = with lib; {
    changelog = "https://github.com/linux-surface/iptsd/releases/tag/${src.rev}";
    description = "Userspace daemon for Intel Precise Touch & Stylus";
    homepage = "https://github.com/linux-surface/iptsd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ tomberek dotlambda ];
    platforms = platforms.linux;
  };
}
