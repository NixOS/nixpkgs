{ stdenv, fetchFromGitHub, fetchpatch, python3, gettext, gobjectIntrospection, wrapGAppsHook, glibcLocales
, gtk3, keybinder3, libnotify, libutempter, vte }:

let
  version = "3.1.0";
in python3.pkgs.buildPythonApplication rec {
  name = "guake-${version}";
  format = "other";

  src = fetchFromGitHub {
    owner = "Guake";
    repo = "guake";
    rev = version;
    sha256 = "0wyis7vxfhwrpq5r72c58k7hqzbk0f5ilm1zffcmbryvy11abgmx";
  };

  patches = [
    # https://github.com/Guake/guake/issues/1264
    (fetchpatch {
      url = https://github.com/Guake/guake/commit/f289aa381bc5fffe83b1ba385c606a2e5cdc94a8.patch;
      sha256 = "038niw44q14fs34nha1lz9vmxhf0l766ni8nsdxpid4crra2wjd3";
    })
  ];

  nativeBuildInputs = [ gettext gobjectIntrospection wrapGAppsHook python3.pkgs.pip glibcLocales ];

  buildInputs = [ gtk3 keybinder3 libnotify python3 vte ];

  propagatedBuildInputs = with python3.pkgs; [ dbus-python pbr pycairo pygobject3 ];

  LC_ALL = "en_US.UTF-8"; # fixes weird encoding error, see https://github.com/NixOS/nixpkgs/pull/38642#issuecomment-379727699

  PBR_VERSION = version; # pbr needs either .git directory, sdist, or env var

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
