{ stdenv, fetchpatch, makeWrapper, fetchFromGitHub, cmake, pkgconfig, libxcb, libpthreadstubs
, libXdmcp, libXau, qtbase, qtdeclarative, qttools, pam, systemd }:

let
  version = "0.12.0";
in
stdenv.mkDerivation rec {
  name = "sddm-${version}";

  src = fetchFromGitHub {
    owner = "sddm";
    repo = "sddm";
    rev = "v${version}";
    sha256 = "09amr61srvl52nvxlqqgs9fzn33pc2gjv5hc83gxx43x6q2j19gg";
  };

  nativeBuildInputs = [ cmake pkgconfig qttools ];

  buildInputs = [ libxcb libpthreadstubs libXdmcp libXau qtbase qtdeclarative pam systemd ];

  cmakeFlags = [ "-DCONFIG_FILE=/etc/sddm.conf" ];

  preConfigure = ''
    export cmakeFlags="$cmakeFlags -DQT_IMPORTS_DIR=$out/lib/qt5/qml -DCMAKE_INSTALL_SYSCONFDIR=$out/etc -DSYSTEMD_SYSTEM_UNIT_DIR=$out/lib/systemd/system"
  '';

  postInstall = ''
    wrapQtProgram $out/bin/sddm
    wrapQtProgram $out/bin/sddm-greeter
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "QML based X11 display manager";
    homepage = https://github.com/sddm/sddm;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
