{
  lib,
  fetchFromGitLab,
  gtksourceview5,
  libspelling,
  fetchFromGitHub,
  python3Packages,
  nodePackages,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  desktop-file-utils,
  gobject-introspection,
  libadwaita,
  webkitgtk_6_0,
  texliveMedium,
  shared-mime-info,
}:

let
  version = "3.2";

  src = fetchFromGitLab {
    owner = "World";
    repo = "apostrophe";
    domain = "gitlab.gnome.org";
    rev = "refs/tags/v${version}";
    hash = "sha256-NPpBu6Wmd8z99vzVQ394CyHRV2RQBtkbuqcaFqKqlkQ=";
  };

  reveal-js = fetchFromGitHub {
    owner = "hakimel";
    repo = "reveal.js";

    # keep in sync with upstream shipped version
    # in build-aux/flatpak/org.gnome.gitlab.somas.Apostrophe.json
    rev = "refs/tags/5.1.0";
    hash = "sha256-L6KVBw20K67lHT07Ws+ZC2DwdURahqyuyjAaK0kTgN0=";
  };
in
python3Packages.buildPythonApplication {
  inherit version src;
  pname = "apostrophe";
  pyproject = false;

  postPatch =
    ''
      substituteInPlace build-aux/meson_post_install.py \
        --replace-fail 'gtk-update-icon-cache' 'gtk4-update-icon-cache'

      patchShebangs --build build-aux/meson_post_install.py
    ''
    # Use mathjax from nixpkgs to avoid loading from CDN
    + ''
      substituteInPlace apostrophe/preview_converter.py \
        --replace-fail "--mathjax" "--mathjax=file://${nodePackages.mathjax}/lib/node_modules/mathjax/es5/tex-chtml-full.js"
    '';

  # Should be done in postInstall, but meson checks this eagerly before build
  preConfigure = ''
    install -d $out/share/apostrophe/libs
    cp -r ${reveal-js} $out/share/apostrophe/libs/reveal.js
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    libadwaita
    gtksourceview5
    libspelling
    webkitgtk_6_0
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pypandoc
    chardet
    levenshtein
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      ''${gappsWrapperArgs[@]}
      --prefix PATH : "${texliveMedium}/bin"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  passthru = {
    inherit reveal-js;
  };

  meta = {
    homepage = "https://gitlab.gnome.org/World/apostrophe";
    description = "Distraction free Markdown editor for GNU/Linux";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers =
      with lib.maintainers;
      [
        sternenseemann
      ]
      ++ lib.teams.gnome-circle.members;
    mainProgram = "apostrophe";
  };
}
