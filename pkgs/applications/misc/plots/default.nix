{ fetchFromGitHub
, gobject-introspection
, lib
, libadwaita
, python3
, wrapGAppsHook
, lmmath
}:
python3.pkgs.buildPythonApplication rec {
  pname = "plots";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "alexhuntley";
    repo = "Plots";
    rev = "v${version}";
    hash = "sha256-GjNpaorxkkhZsqrKq4kO5nqF5+4I4tmSc023AZpY8Sw=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = [
    libadwaita
    (python3.withPackages (p: with p; [
      numpy
      pygobject3
      lark
      jinja2
      freetype-py
      pyopengl
      pycairo
      pyglm
    ]))
  ];

  nativeCheckInputs = [
    (python3.withPackages (p: with p; [
      pytest
    ]))
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

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

  meta = with lib; {
    description = "Graph plotting app for GNOME";
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
