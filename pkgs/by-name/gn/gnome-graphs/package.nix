{ lib
, python3Packages
, fetchFromGitLab
, meson
, ninja
, vala
, pkg-config
, gobject-introspection
, blueprint-compiler
, wrapGAppsHook4
, desktop-file-utils
, shared-mime-info
, libadwaita
}:

python3Packages.buildPythonApplication rec {
  pname = "gnome-graphs";
  version = "1.7.2";
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Graphs";
    rev = "v${version}";
    hash = "sha256-CgCLOkKrMEN0Jnib5NZyVa+s3ico2ANt0ALGa4we3Ak=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    gobject-introspection
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
    shared-mime-info
  ];

  buildInputs = [
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    numpy
    numexpr
    sympy
    scipy
    matplotlib
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix LD_LIBRARY_PATH : $out/lib
    )
  '';

  meta = with lib; {
    description = "Simple, yet powerful tool that allows you to plot and manipulate your data with ease";
    homepage = "https://apps.gnome.org/Graphs";
    license = licenses.gpl3Plus;
    mainProgram = "graphs";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux; # locale.bindtextdomain only available on linux
  };
}
