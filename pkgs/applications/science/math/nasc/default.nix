{ stdenv
, fetchFromGitHub
, fetchpatch
, pkgconfig
, gtk3
, granite
, gnome3
, cmake
, vala_0_40
, libqalculate
, gobject-introspection
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "nasc-${version}";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "parnold-x";
    repo = "nasc";
    rev = version;
    sha256 = "13y5fnm7g3xgdxmdydlgly73nigh8maqbf9d6c9bpyzxkxq1csy5";
  };

  postPatch = ''
    # libqalculatenasc.so is not installed, and nasc fails to start
    substituteInPlace libqalculatenasc/CMakeLists.txt --replace SHARED STATIC
  '';

  nativeBuildInputs = [
    pkgconfig
    wrapGAppsHook
    vala_0_40 # should be `elementary.vala` when elementary attribute set is merged
    cmake
    gobject-introspection # for setup-hook
  ];

  buildInputs = [
    gnome3.defaultIconTheme # should be `elementary.defaultIconTheme`when elementary attribute set is merged
    gnome3.gtksourceview
    gnome3.libgee
    gnome3.libsoup
    granite
    gtk3
    libqalculate
  ];

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
