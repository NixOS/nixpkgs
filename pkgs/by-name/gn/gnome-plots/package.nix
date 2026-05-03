{
  lib,
  python3,
  fetchFromGitHub,
  wrapGAppsHook3,
  gobject-introspection,
  gtk3,
  libadwaita,
  libGL,
  freetype,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "gnome-plots";
  version = "0.8.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alexhuntley";
    repo = "Plots";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GjNpaorxkkhZsqrKq4kO5nqF5+4I4tmSc023AZpY8Sw=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3.pkgs; [
    pygobject3
    pyopengl
    jinja2
    numpy
    lark
    pyglm
    freetype-py
  ];

  postInstall = ''
    # Install desktop entry and icons
    install -Dm644 res/com.github.alexhuntley.Plots.desktop \
      $out/share/applications/com.github.alexhuntley.Plots.desktop
    install -Dm644 res/com.github.alexhuntley.Plots.svg \
      $out/share/icons/hicolor/scalable/apps/com.github.alexhuntley.Plots.svg
    install -Dm644 res/com.github.alexhuntley.Plots-symbolic.svg \
      $out/share/icons/hicolor/symbolic/apps/com.github.alexhuntley.Plots-symbolic.svg
    install -Dm644 res/com.github.alexhuntley.Plots.metainfo.xml \
      $out/share/metainfo/com.github.alexhuntley.Plots.metainfo.xml
  '';

  meta = with lib; {
    description = "A graph plotting app for GNOME";
    longDescription = ''
      Plots makes it easy to visualise mathematical formulae. In addition to
      basic arithmetic operations, it supports trigonometric, hyperbolic,
      exponential and logarithmic functions, as well as arbitrary sums and
      products. It can display polar equations, and both implicit and explicit
      Cartesian equations. Uses OpenGL 3.3+.
    '';
    homepage = "https://github.com/alexhuntley/Plots";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rpmcruz ];
    mainProgram = "plots";
    platforms = platforms.linux;
  };
})
