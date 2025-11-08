{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  libxml2,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "libwebcam";
  version = "0.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/source/${pname}-src-${version}.tar.gz";
    sha256 = "0hcxv8di83fk41zjh0v592qm7c0v37a3m3n3lxavd643gff1k99w";
  };

  patches = [
    ./uvcdynctrl_symlink_support_and_take_data_dir_from_env.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    udevCheckHook
  ];
  buildInputs = [ libxml2 ];

  postPatch = ''
    substituteInPlace ./uvcdynctrl/CMakeLists.txt \
      --replace-fail "/lib/udev" "$out/lib/udev" \
      --replace-fail "cmake_minimum_required (VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"

    substituteInPlace ./uvcdynctrl/udev/scripts/uvcdynctrl \
      --replace-fail 'debug=0' 'debug=''${NIX_UVCDYNCTRL_UDEV_DEBUG:-0}' \
      --replace-fail 'uvcdynctrlpath=uvcdynctrl' "uvcdynctrlpath=$out/bin/uvcdynctrl"

    substituteInPlace ./uvcdynctrl/udev/rules/80-uvcdynctrl.rules \
      --replace-fail "/lib/udev" "$out/lib/udev"

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace libwebcam/CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"
  '';

  preConfigure = ''
    cmakeFlagsArray=(
      $cmakeFlagsArray
      "-DCMAKE_INSTALL_PREFIX=$out"
    )
  '';

  doInstallCheck = true;

  meta = with lib; {
    description = "Webcam-tools package";
    platforms = platforms.linux;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
