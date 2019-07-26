{ stdenv, fetchFromGitHub, pidgin, glib, libnotify, purple-events, autoreconfHook, pkgconfig, intltool }:

stdenv.mkDerivation rec {
  pname = "purple-libnotify-plus";
  version = "2018-05-30";

  src = fetchFromGitHub {
    owner = "sardemff7";
    repo = pname;
    rev = "67987f8427b722a2edce75678254ad27ae56297d";
    sha256 = "0gh86dknzd064y2d8nck4p8r6ci23vwrlhgy1q75mmc0px94gz34";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig intltool ];
  autoreconfPhase = "${stdenv.shell} ./autogen.sh";
  buildInputs = [ pidgin glib libnotify purple-events ];

  configureFlags = [ "--with-purple-plugindir=${placeholder "out"}/lib/purple-2" ];

  meta = with stdenv.lib; {
    homepage = http://purple-libnotify-plus.sardemff7.net/;
    description = "Plugin to provide libnotify interface to Pidgin and Finch";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
