{ lib, stdenv, fetchurl, libhdhomerun, pkg-config, gtk2 }:

stdenv.mkDerivation rec {
  pname = "hdhomerun-config-gui";
  version = "20221031";

  src = fetchurl {
    url = "https://download.silicondust.com/hdhomerun/hdhomerun_config_gui_${version}.tgz";
    sha256 = "17zf0hzw68b0xdkh1maqhl96jb7171mbhd29y64as29nps9x4fmz";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 libhdhomerun ];

  configureFlags = [ "CPPFLAGS=-I${libhdhomerun}/include/hdhomerun" ];
  makeFlags = [ "SUBDIRS=src" ];

  installPhase = ''
    runHook preInstall
    install -vDm 755 src/hdhomerun_config_gui $out/bin/hdhomerun_config_gui
    runHook postInstall
  '';

  meta = with lib; {
    description = "GUI for configuring Silicondust HDHomeRun TV tuners";
    homepage = "https://www.silicondust.com/support/linux";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.louisdk1 ];
  };
}
