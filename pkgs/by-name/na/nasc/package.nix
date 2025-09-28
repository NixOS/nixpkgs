{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3,
  meson,
  ninja,
  vala,
  gtk3,
  glib,
  pantheon,
  gtksourceview,
  libgee,
  nix-update-script,
  webkitgtk_4_0,
  libqalculate,
  intltool,
  gnuplot,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "nasc";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "parnold-x";
    repo = "nasc";
    tag = version;
    sha256 = "02b9a59a9fzsb6nn3ycwwbcbv04qfzm6x7csq2addpzx5wak6dd8";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    glib # post_install.py
    gtk3 # post_install.py
    intltool # for libqalculate
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    gtksourceview
    libgee
    pantheon.granite
    webkitgtk_4_0
    # We add libqalculate's runtime dependencies because nasc has it as a modified subproject.
  ]
  ++ libqalculate.buildInputs
  ++ libqalculate.propagatedBuildInputs;

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py

    # patch subproject. same code in libqalculate expression
    substituteInPlace subprojects/libqalculate/libqalculate/Calculator-plot.cc \
      --replace 'commandline = "gnuplot"' 'commandline = "${gnuplot}/bin/gnuplot"' \
      --replace '"gnuplot - ' '"${gnuplot}/bin/gnuplot - '
    substituteInPlace subprojects/libqalculate/libqalculate/meson.build \
      --replace "link_with: 'libqalculate_lib_static'" "link_with: libqalculate_lib_static"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Do maths like a normal person, designed for elementary OS";
    longDescription = ''
      It’s an app where you do maths like a normal person. It lets you
      type whatever you want and smartly figures out what is math and
      spits out an answer on the right pane. Then you can plug those
      answers in to future equations and if that answer changes, so does
      the equations it’s used in.
    '';
    homepage = "https://github.com/parnold-x/nasc";
    teams = [ teams.pantheon ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    mainProgram = "com.github.parnold_x.nasc";
  };
}
