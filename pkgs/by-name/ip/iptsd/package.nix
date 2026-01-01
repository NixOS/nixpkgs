{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  meson,
  ninja,
  pkg-config,
  cli11,
  eigen,
  hidrd,
  inih,
  microsoft-gsl,
  spdlog,
  systemd,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "iptsd";
<<<<<<< HEAD
  version = "3.1.0";
=======
  version = "3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = "iptsd";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-2yYO1xb576IHaJquTrQtmAjJITGdW06I3eHD+HR88xI=";
=======
    hash = "sha256-3z3A9qywmsSW1tlJ6LePC5wudM/FITTAFyuPkbHlid0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    meson
    ninja
    pkg-config
    udevCheckHook
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    cli11
    eigen
    hidrd
    inih
    microsoft-gsl
    spdlog
    systemd
  ];

  doInstallCheck = true;

  # Original installs udev rules and service config into global paths
  postPatch = ''
    substituteInPlace etc/meson.build \
      --replace-fail "install_dir: unitdir" "install_dir: '$out/etc/systemd/system'" \
      --replace-fail "install_dir: rulesdir" "install_dir: '$out/etc/udev/rules.d'"
    substituteInPlace etc/scripts/iptsd-find-service \
      --replace-fail "systemd-escape" "${lib.getExe' systemd "systemd-escape"}"
    substituteInPlace etc/udev/50-iptsd.rules.in \
      --replace-fail "/bin/systemd-escape" "${lib.getExe' systemd "systemd-escape"}"
  '';

  mesonFlags = [
    "-Dservice_manager=systemd"
    "-Dsample_config=false"
    "-Ddebug_tools="
    "-Db_lto=false" # plugin needed to handle lto object -> undefined reference to ...
  ];

  meta = {
    changelog = "https://github.com/linux-surface/iptsd/releases/tag/v${version}";
    description = "Userspace daemon for Intel Precise Touch & Stylus";
    homepage = "https://github.com/linux-surface/iptsd";
    license = lib.licenses.gpl2Plus;
    mainProgram = "iptsd";
    maintainers = with lib.maintainers; [
      tomberek
      dotlambda
    ];
    platforms = lib.platforms.linux;
  };
}
