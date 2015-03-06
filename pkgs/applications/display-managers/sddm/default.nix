{ stdenv, fetchpatch, makeWrapper, fetchFromGitHub, cmake, pkgconfig, libxcb, libpthreadstubs
, libXdmcp, libXau, qt5, pam, systemd }:

let
  version = "0.11.0";
in
stdenv.mkDerivation rec {
  name = "sddm-${version}";

  src = fetchFromGitHub {
    owner = "sddm";
    repo = "sddm";
    rev = "v${version}";
    sha256 = "1s1gm0xvgwzrpxgni3ngdj8phzg21gkk1jyiv2l2i5ayl0jdm7ig";
  };

  nativeBuildInputs = [ cmake pkgconfig qt5.tools makeWrapper ];

  buildInputs = [ libxcb libpthreadstubs libXdmcp libXau qt5.base pam systemd ];

  patches = [ (fetchpatch {
                url = "https://github.com/sddm/sddm/commit/9bc21ee7da5de6b2531d47d1af4d7b0a169990b9.patch";
                sha256 = "1pda0wf4xljdadja7iyh5c48h0347imadg9ya1dw5slgb7w1d94l";
              })
              ./cmake_paths.patch
            ];

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
    homepage = http://launchpad.net/lightdm;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
