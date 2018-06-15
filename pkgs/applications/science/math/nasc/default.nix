{ stdenv
, bash
, gnused
, fetchFromGitHub
, gettext
, pkgconfig
, gtk3
, granite
, gnome3
, cmake
, ninja
, vala
, libqalculate
, elementary-cmake-modules
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "nasc-${version}";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "parnold-x";
    repo = "nasc";
    rev = version;
    sha256 = "01n4ldj5phrsv97vb04qvs9c1ip6v8wygx9llj704hly1il9fb54";
  };

  XDG_DATA_DIRS = stdenv.lib.concatStringsSep ":" [
    "${granite}/share"
    "${gnome3.libgee}/share"
  ];

  nativeBuildInputs = [
    pkgconfig
    wrapGAppsHook
    vala
    cmake
    gettext
  ];
  buildInputs = [
    libqalculate
    gtk3
    granite
    gnome3.libgee
    gnome3.libsoup
    gnome3.gtksourceview
  ];

  prePatch = ''
    substituteInPlace ./libqalculatenasc/libtool \
      --replace "/bin/bash" "${bash}/bin/bash" \
      --replace "/bin/sed" "${gnused}/bin/sed"
    substituteInPlace ./libqalculatenasc/configure.inc \
      --replace 'ac_default_path="/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin"' 'ac_default_path=$PATH'
  '';

  meta = with stdenv.lib; {
    description = "Do maths like a normal person";
    longDescription = ''
      It’s an app where you do maths like a normal person. It lets you
      type whatever you want and smartly figures out what is math and
      spits out an answer on the right pane. Then you can plug those
      answers in to future equations and if that answer changes, so does
      the equations it’s used in.
    '';
    homepage = https://github.com/parnold-x/nasc;
    maintainers = with maintainers; [ samdroid-apps ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
