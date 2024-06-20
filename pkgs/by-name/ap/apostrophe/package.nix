{
  lib,
  fetchFromGitLab,
  gtksourceview5,
  libspelling,
  fetchFromGitHub,
  python3Packages,
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
  version = "3.0";

  src = fetchFromGitLab {
    owner = "World";
    repo = "apostrophe";
    domain = "gitlab.gnome.org";
    rev = "v${version}";
    sha256 = "sha256-wKxRCU00nSk7F8IZNWoLRtGs3m6ol3UBnArtppUOz/g=";
  };

  # Patches are required by upstream. Without the patches
  # typing `- aaa`, newline, `- bbb` the program crashes
  gtksourceview5-patched = gtksourceview5.overrideAttrs (prev: {
    patches = (prev.patches or [ ]) ++ [ "${src}/build-aux/flatpak/sourceview_text_commits.patch" ];
  });

  libspelling-patched =
    (libspelling.override { gtksourceview5 = gtksourceview5-patched; }).overrideAttrs
      (prev: {
        patches = (prev.patches or [ ]) ++ [ "${src}/build-aux/flatpak/libspelling_text_commits.patch" ];
      });

  reveal-js = fetchFromGitHub {
    owner = "hakimel";
    repo = "reveal.js";

    # keep in sync with upstream shipped version
    # in build-aux/flatpak/org.gnome.gitlab.somas.Apostrophe.json
    rev = "4.6.0";
    hash = "sha256-a+J+GasFmRvu5cJ1GLXscoJ+owzFXsLhCbeDbYChkyQ=";
  };
in
python3Packages.buildPythonApplication rec {
  inherit version src;
  pname = "apostrophe";
  pyproject = false;

  postPatch =
    ''
      substituteInPlace build-aux/meson_post_install.py \
        --replace-fail 'gtk-update-icon-cache' 'gtk4-update-icon-cache'

      patchShebangs --build build-aux/meson_post_install.py
    ''
    # Should be done in postInstall, but meson checks this eagerly before build
    + ''
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
    gtksourceview5-patched
    libspelling-patched
    webkitgtk_6_0
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pypandoc
    chardet
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
    inherit gtksourceview5-patched libspelling-patched reveal-js;
  };

  meta = {
    homepage = "https://gitlab.gnome.org/World/apostrophe";
    description = "Distraction free Markdown editor for GNU/Linux";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      sternenseemann
      aleksana
    ];
    mainProgram = "apostrophe";
  };
}
