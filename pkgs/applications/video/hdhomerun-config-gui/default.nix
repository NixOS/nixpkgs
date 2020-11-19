{ stdenv, fetchurl, libhdhomerun, gcc, gnumake, pkg-config, gtk2 }:

stdenv.mkDerivation rec {
  pname = "hdhomerun-config-gui";
  version = "20200521";

  src = fetchurl {
    url = "https://download.silicondust.com/hdhomerun/hdhomerun_config_gui_${version}.tgz";
    sha256 = "1r1rwfgi714nwblyg8nqjzkpm4n2lg7kqqqas47hvbn5waimz1ja";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 libhdhomerun ];

  configureFlags = [ "CPPFLAGS=-I${libhdhomerun}/include/hdhomerun" ];
  makeFlags = [ "SUBDIRS=src" ];

  installPhase = ''
    install -vDm 755 src/hdhomerun_config_gui $out/usr/bin/hdhomerun_config_gui
  '';

  meta = with stdenv.lib; {
    description = "GUI for configuring Silicondust HDHomeRun TV tuners";
    homepage = "https://www.silicondust.com/support/linux";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.louisdk1 ];
  };
}
