{ lib
, fetchFromGitHub
, python3Packages
, gobject-introspection
, libadwaita
, wrapGAppsHook4
, lmmath
}:

python3Packages.buildPythonApplication rec {
  pname = "plots";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "alexhuntley";
    repo = "Plots";
    rev = "v${version}";
    hash = "sha256-GjNpaorxkkhZsqrKq4kO5nqF5+4I4tmSc023AZpY8Sw=";
  };

  nativeBuildInputs = [ gobject-introspection wrapGAppsHook4 ];
  buildInputs = [ libadwaita ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    numpy
    lark
    jinja2
    freetype-py
    pyopengl
    pycairo
    pyglm
  ];

  nativeCheckInputs = with python3Packages; [ pytest ];

  postInstall = ''
    install -D ${lmmath}/share/fonts/opentype/latinmodern-math.otf -t $out/share/fonts/

    install -D res/com.github.alexhuntley.Plots.metainfo.xml -t $out/share/metainfo/
    install -D res/com.github.alexhuntley.Plots.desktop -t $out/share/applications/
    install -D res/com.github.alexhuntley.Plots.svg -t $out/share/icons/hicolor/scalable/apps/
    install -D res/com.github.alexhuntley.Plots-symbolic.svg -t $out/share/icons/hicolor/symbolic/apps/

    for lang_dir in help/*; do
      lang=$(basename "$lang_dir")
      install -D -t $out/share/help/$lang/plots/ $lang_dir/*
    done
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Graph plotting app for GNOME";
    mainProgram = "plots";
    longDescription = ''
      Plots is a graph plotting app for GNOME.
      Plots makes it easy to visualise mathematical formulae.
      In addition to basic arithmetic operations, it supports trigonometric, hyperbolic, exponential and logarithmic functions, as well as arbitrary sums and products.
      It can display polar equations, and both implicit and explicit Cartesian equations.
    '';
    homepage = "https://github.com/alexhuntley/Plots";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sund3RRR ];
  };
}
