{ lib, python3Packages, fetchFromGitHub, glib, wrapGAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "printrun";
  version = "2.0.0rc5";

  src = fetchFromGitHub {
    owner = "kliment";
    repo = "Printrun";
    rev = "${pname}-${version}";
    sha256 = "179x8lwrw2h7cxnkq7izny6qcb4nhjnd8zx893i77zfhzsa6kx81";
  };

  nativeBuildInputs = [ glib wrapGAppsHook ];

  propagatedBuildInputs = with python3Packages; [
    appdirs cython dbus-python numpy six wxPython_4_0 psutil pyglet pyopengl pyserial
  ];

  doCheck = false;

  setupPyBuildFlags = ["-i"];

  postPatch = ''
    sed -i -r "s|/usr(/local)?/share/|$out/share/|g" printrun/utils.py
  '';

  postInstall = ''
    for f in $out/share/applications/*.desktop; do
      sed -i -e "s|/usr/|$out/|g" "$f"
    done
  '';

  dontWrapGApps = true;
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Pronterface, Pronsole, and Printcore - Pure Python 3d printing host software";
    homepage = "https://github.com/kliment/Printrun";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
