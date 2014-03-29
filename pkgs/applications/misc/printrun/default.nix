{ stdenv, python27Packages, fetchgit }:
let
  py = python27Packages;
in
py.buildPythonPackage rec {
  name = "printrun";

  src = fetchgit {
    url = "https://github.com/kliment/Printrun";
    rev = "0a7f2335d0c02c3cc283200867b41f8b337b1387";
    sha256 = "1zvh5ih89isv51sraljm29z9k00srrdnklwkyp27ymxzlbcwq6gv";
  };

  propagatedBuildInputs = [ py.wxPython py.pyserial py.dbus py.psutil ];

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
