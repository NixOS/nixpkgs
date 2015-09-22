{ stdenv, fetchpatch, makeWrapper, fetchFromGitHub, cmake, pkgconfig, libxcb, libpthreadstubs
, libXdmcp, libXau, qt5, pam, systemd }:

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

  nativeBuildInputs = [ cmake pkgconfig qt5.tools makeWrapper ];

  buildInputs = [ libxcb libpthreadstubs libXdmcp libXau qt5.base pam systemd ];

  cmakeFlags = [ "-DCONFIG_FILE=/etc/sddm.conf" ];

  preConfigure = ''
    export cmakeFlags="$cmakeFlags -DQT_IMPORTS_DIR=$out/lib/qt5/qml -DCMAKE_INSTALL_SYSCONFDIR=$out/etc -DSYSTEMD_SYSTEM_UNIT_DIR=$out/lib/systemd/system"
  '';

  postInstall = ''
    wrapProgram $out/bin/sddm-greeter \
      --set QML2_IMPORT_PATH "${qt5.declarative}/lib/qt5/qml/"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "QML based X11 display manager";
    homepage = https://github.com/sddm/sddm;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
