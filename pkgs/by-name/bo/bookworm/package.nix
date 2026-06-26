{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream,
  coreutils,
  curl,
  desktop-file-utils,
  glib,
  gnugrep,
  gobject-introspection,
  gtk3,
  html2text,
  libgee,
  libxml2,
  meson,
  ninja,
  pantheon,
  pkg-config,
  poppler,
  poppler-utils,
  python3,
  sqlite,
  unar,
  unzip,
  vala,
  webkitgtk_4_1,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "bookworm";
  version = "unstable-2026-05-28";

  src = fetchFromGitHub {
    owner = "babluboy";
    repo = "bookworm";
    rev = "fa06f1b80bb2372c1f20b0cfb21dc88eed410e29";
    hash = "sha256-xml6jOE0tJBz1CwE+0ecSbiGAajh398bw+leFapctiE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    appstream
    desktop-file-utils
    glib
    gtk3
    html2text
    libgee
    libxml2
    pantheon.granite
    poppler
    python3
    sqlite
    webkitgtk_4_1
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
    substituteInPlace meson.build \
      --replace-fail "webkit2gtk-4.0" "webkit2gtk-4.1"
    substituteInPlace src/window.vala \
      --replace-fail "Soup.URI.decode" "Uri.unescape_string"
    substituteInPlace src/utils.vala \
      --replace-fail "Soup.URI.decode" "Uri.unescape_string"
  '';

  # These programs are expected in PATH from the source code and scripts
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${
        lib.makeBinPath [
          unzip
          unar
          poppler-utils
          html2text
          coreutils
          curl
          gnugrep
        ]
      }"
      --prefix PATH : $out/bin
    )
  '';

  postFixup = ''
    patchShebangs $out/share/bookworm/scripts/mobi_lib/*.py
    patchShebangs $out/share/bookworm/scripts/tasks/*.sh
  '';

  meta = {
    description = "Simple, focused eBook reader";
    mainProgram = "com.github.babluboy.bookworm";
    longDescription = ''
      Read the books you love without having to worry about different format complexities like epub, pdf, mobi, cbr, etc.
    '';
    homepage = "https://babluboy.github.io/bookworm/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
