{ lib
, stdenv
, fetchFromGitHub
, appstream
, coreutils
, curl
, desktop-file-utils
, glib
, gnugrep
, gobject-introspection
, gtk3
, html2text
, libgee
, libxml2
, meson
, ninja
, pantheon
, pkg-config
, poppler
, poppler_utils
, python3
, sqlite
, unar
, unzip
, vala
, webkitgtk
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "bookworm";
  version = "unstable-2022-01-09";

  src = fetchFromGitHub {
    owner = "babluboy";
    repo = pname;
    rev = "f3df858ce748a6bbc43f03a6e261ff76a6d7d303";
    hash = "sha256-mLyJfblF5WnWBV3rX1ZRupccou4t5mBpo3W7+ECNMVI=";
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
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  # These programs are expected in PATH from the source code and scripts
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ unzip unar poppler_utils html2text coreutils curl gnugrep ]}"
      --prefix PATH : $out/bin
    )
  '';

  postFixup = ''
    patchShebangs $out/share/bookworm/scripts/mobi_lib/*.py
    patchShebangs $out/share/bookworm/scripts/tasks/*.sh
  '';

  meta = with lib; {
    description = "A simple, focused eBook reader";
    mainProgram = "com.github.babluboy.bookworm";
    longDescription = ''
      Read the books you love without having to worry about different format complexities like epub, pdf, mobi, cbr, etc.
    '';
    homepage = "https://babluboy.github.io/bookworm/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
