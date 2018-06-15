{ stdenv, fetchFromGitHub, python3, gettext, gobjectIntrospection, wrapGAppsHook, glibcLocales
, gtk3, keybinder3, libnotify, libutempter, vte }:

let
  version = "3.2.2";
in python3.pkgs.buildPythonApplication rec {
  name = "guake-${version}";
  format = "other";

  src = fetchFromGitHub {
    owner = "Guake";
    repo = "guake";
    rev = version;
    sha256 = "1wx8vghn0h52xryyn6cf9z1lbwsk766lhff162szbaxlxyl6xsc0";
  };

  nativeBuildInputs = [ gettext gobjectIntrospection wrapGAppsHook python3.pkgs.pip glibcLocales ];

  buildInputs = [ gtk3 keybinder3 libnotify python3 vte ];

  propagatedBuildInputs = with python3.pkgs; [ dbus-python pbr pycairo pygobject3 ];

  LC_ALL = "en_US.UTF-8"; # fixes weird encoding error, see https://github.com/NixOS/nixpkgs/pull/38642#issuecomment-379727699

  PBR_VERSION = version; # pbr needs either .git directory, sdist, or env var

  postPatch = ''
    # unnecessary /usr/bin/env in Makefile
    # https://github.com/Guake/guake/pull/1285
    substituteInPlace "Makefile" --replace "/usr/bin/env python3" "python3"
  '';

  makeFlags = [
    "prefix=$(out)"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ libutempter ]}")
  '';

  meta = with stdenv.lib; {
    description = "Drop-down terminal for GNOME";
    homepage = http://guake-project.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
