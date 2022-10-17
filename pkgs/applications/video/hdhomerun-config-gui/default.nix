{ lib, stdenv, fetchurl, libhdhomerun, pkg-config, gtk2 }:

stdenv.mkDerivation rec {
  pname = "hdhomerun-config-gui";
  version = "20210224";

  src = fetchurl {
    url = "https://download.silicondust.com/hdhomerun/hdhomerun_config_gui_${version}.tgz";
    sha256 = "sha256-vzrSk742Ca2I8Uk0uGo44SxpEoVY1QBn62Ahwz8E7p8=";
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
