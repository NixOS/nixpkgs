{ lib
, fetchFromGitLab
, fetchpatch
, desktop-file-utils
, gettext
, glib
, gobject-introspection
, gtk4
, libadwaita
, libnotify
, webkitgtk_6_0
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook4
, nix-update-script
}:

python3.pkgs.buildPythonApplication rec {
  pname = "komikku";
  version = "1.17.0";

  format = "other";

  src = fetchFromGitLab {
    owner = "valos";
    repo = "Komikku";
    rev = "v${version}";
    hash = "sha256-DxW9uefY6Fks3qSUeLMp3BB85SfLgzwBr4KO9do2y2o=";
  };

  patches = [
    # https://gitlab.com/valos/Komikku/-/merge_requests/208
    (fetchpatch {
      url = "https://gitlab.com/valos/Komikku/-/commit/c9a09817acd767a7cb4ceea9b212fffd798eae61.patch";
      hash = "sha256-McjQApLY7OKbdelrTeh3aRw90B6T9V5FtLL5Y62BmGA=";
    })
    (fetchpatch {
      url = "https://gitlab.com/valos/Komikku/-/commit/bda93631420f6a69a50be0068f259d60b9558930.patch";
      hash = "sha256-Xu+IaQKf0I99a2uh97j8xSlGYSJHuNPMy/zZtWRxLaM=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gettext
    glib # for glib-compile-resources
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libnotify
    webkitgtk_6_0
    gobject-introspection
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    beautifulsoup4
    brotli
    cloudscraper
    dateparser
    emoji
    keyring
    lxml
    python-magic
    natsort
    piexif
    pillow
    pure-protobuf
    rarfile
    unidecode
  ];

  # Tests require network
  doCheck = false;

  # Prevent double wrapping.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
    )
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "komikku";
    };
  };

  meta = with lib; {
    description = "Manga reader for GNOME";
    homepage = "https://valos.gitlab.io/Komikku/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu infinitivewitch ];
  };
}
