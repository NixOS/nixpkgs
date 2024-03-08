{ lib, stdenv, fetchurl, alsa-lib-with-plugins, libX11, tcl, tk }:

stdenv.mkDerivation  rec {
  pname = "vkeybd";
  version = "0.1.18d";

  src = fetchurl {
    url = "ftp://ftp.suse.com/pub/people/tiwai/vkeybd/${pname}-${version}.tar.bz2";
    sha256 = "0107b5j1gf7dwp7qb4w2snj4bqiyps53d66qzl2rwj4jfpakws5a";
  };

  buildInputs = [ alsa-lib-with-plugins libX11 tcl tk ];

  configurePhase = ''
    mkdir -p $out/bin
    sed -e "s@/usr/local@$out@" -i Makefile
  '';

  makeFlags = [ "TKLIB=-l${tk.libPrefix}" "TCLLIB=-l${tcl.libPrefix}" ];

  meta = with lib; {
    description = "Virtual MIDI keyboard";
    homepage = "https://www.alsa-project.org/~tiwai/alsa.html";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
