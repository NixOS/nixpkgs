{ stdenv, python27Packages, fetchgit }:
let
  py = python27Packages;
in
py.buildPythonPackage rec {
  name = "printrun";

  src = fetchgit {
    url = "https://github.com/kliment/Printrun";
    rev = "2299962bb338d3f4335b97211ee609ebaea008f7"; # printrun-20140801
    sha256 = "19nay7xclm36x56hpm87gw4ca6rnygpqaw5ypbmrz0hyxx140abj";
  };

  propagatedBuildInputs = with py; [ wxPython30 pyserial dbus psutil
    numpy pyopengl pyglet cython ];

  doCheck = false;

  postPatch = ''
    sed -i -r "s|/usr(/local)?/share/|$out/share/|g" printrun/utils.py
    sed -i "s|distutils.core|setuptools|" setup.py
    sed -i "s|distutils.command.install |setuptools.command.install |" setup.py
  '';

  postInstall = ''
    for f in $out/share/applications/*.desktop; do
      sed -i -e "s|/usr/|$out/|g" "$f"
    done
  '';

  meta = with stdenv.lib; {
    description = "Pronterface, Pronsole, and Printcore - Pure Python 3d printing host software";
    homepage = https://github.com/kliment/Printrun;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
