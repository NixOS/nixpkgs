{ pkgs, stdenv, fetchurl, pythonPackages, buildPythonPackage, pygtk, ffmpeg, mplayer, vcdimager, cdrkit, dvdauthor }:

let
  inherit (pythonPackages) dbus;

in buildPythonPackage rec {
  name = "devede-3.23.0";
  namePrefix = "";

  src = fetchurl {
    url = "http://www.rastersoft.com/descargas/${name}.tar.bz2";
    sha256 = "9e217ca46f5f275cb0c3cadbe8c830fa1fde774c004bd95a343d1255be6f25e1";
  };

  buildInputs = [ ffmpeg ];

  pythonPath = [ pygtk dbus ffmpeg mplayer dvdauthor vcdimager cdrkit ];

  postPatch = ''
    substituteInPlace devede --replace "/usr/share/devede" "$out/share/devede"

  '';

  meta = with stdenv.lib; {
    description = "DVD Creator for Linux";
    homepage = http://www.rastersoft.com/programas/devede.html;
    license = licenses.gpl3;
    maintainers = [ maintainers.bdimcheff ];
  };
}
