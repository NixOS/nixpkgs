{ stdenv
, fetchFromGitHub
, meson
, ninja
, vala
, pkg-config
, pantheon
, python3
, desktop-file-utils
, glib
, graphviz
, gtk3
, gtksourceview
, libgee
, substituteAll
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "graphui";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "artemanufrij";
    repo = pname;
    rev = version;
    sha256 = "19r44rw0chvj7yrqf35rvpg1yziv25d43h392qnwbmifnq1kbfcs";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      graphviz = "${graphviz}/bin/";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    python3
    desktop-file-utils
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    gtksourceview
    graphviz
    libgee
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Graph visualization based on graphviz";
    homepage = "https://github.com/artemanufrij/graphui";
    maintainers = with maintainers; [ kjuvi ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
  
