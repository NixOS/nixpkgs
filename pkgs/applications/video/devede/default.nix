{ pkgs, stdenv, fetchFromGitHub, python3Packages, ffmpeg, mplayer, vcdimager, cdrkit, dvdauthor
, gtk3, gettext, wrapGAppsHook, gdk_pixbuf }:

let
  inherit (python3Packages) dbus-python buildPythonApplication pygobject3 urllib3;

in buildPythonApplication rec {
  name = "devede-4.8.8";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "rastersoft";
    repo = "devedeng";
    rev = "c518683fbcd793aa92249e4fecafc3c3fea7da68";
    sha256 = "0ncb8nykchrjlllbzfjpvirmfvfaps9qhilc56kvcw3nzqrnkx8q";
  };

  nativeBuildInputs = [
    gettext wrapGAppsHook
  ];

  buildInputs = [
    ffmpeg
  ];

  propagatedBuildInputs = [
    gtk3 pygobject3 gdk_pixbuf dbus-python ffmpeg mplayer dvdauthor vcdimager cdrkit urllib3
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "'/usr'," ""
    substituteInPlace src/devedeng/configuration_data.py \
      --replace "/usr/share" "$out/share" \
      --replace "/usr/local/share" "$out/share"
  '';

  meta = with stdenv.lib; {
    description = "DVD Creator for Linux";
    homepage = http://www.rastersoft.com/programas/devede.html;
    license = licenses.gpl3;
    maintainers = [ maintainers.bdimcheff ];
  };
}
