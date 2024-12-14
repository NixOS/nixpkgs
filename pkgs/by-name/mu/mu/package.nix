{
  lib,
  stdenv,
  fetchFromGitHub,
  glibcLocales,
  meson,
  ninja,
  pkg-config,
  python3,
  cld2,
  coreutils,
  emacs,
  glib,
  gmime3,
  texinfo,
  xapian,
}:

stdenv.mkDerivation rec {
  pname = "mu";
  version = "1.12.7";

  outputs = [
    "out"
    "mu4e"
  ];

  src = fetchFromGitHub {
    owner = "djcb";
    repo = "mu";
    rev = "v${version}";
    hash = "sha256-FhmxF+ID8w1aVRKQ3gg5aY/dYWiGlO0TC9SDak7uzGI=";
  };

  postPatch = ''
    substituteInPlace lib/utils/mu-utils-file.cc \
      --replace-fail "/bin/rm" "${coreutils}/bin/rm"
    substituteInPlace lib/tests/bench-indexer.cc \
      --replace-fail "/bin/rm" "${coreutils}/bin/rm"
    substituteInPlace lib/mu-maildir.cc \
      --replace-fail "/bin/mv" "${coreutils}/bin/mv"
    patchShebangs build-aux/date.py
  '';

  postInstall = ''
    rm --verbose $mu4e/share/emacs/site-lisp/mu4e/*.elc
  '';

  # move only the mu4e info manual
  # this has to be after preFixup otherwise the info manual may be moved back by _multioutDocs()
  # we manually move the mu4e info manual instead of setting
  # outputInfo to mu4e because we do not want to move the mu-guile
  # info manual (if it exists)
  postFixup = ''
    moveToOutput share/info/mu4e.info.gz $mu4e
    install-info $mu4e/share/info/mu4e.info.gz $mu4e/share/info/dir
    if [[ -a ''${!outputInfo}/share/info/mu-guile.info.gz ]]; then
      install-info --delete $mu4e/share/info/mu4e.info.gz ''${!outputInfo}/share/info/dir
    else
      rm --verbose --recursive ''${!outputInfo}/share/info
    fi
  '';

  buildInputs = [
    cld2
    emacs
    glib
    gmime3
    texinfo
    xapian
  ];

  mesonFlags = [
    "-Dguile=disabled"
    "-Dreadline=disabled"
    "-Dlispdir=${placeholder "mu4e"}/share/emacs/site-lisp"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
    glibcLocales
  ];

  doCheck = true;

  # Tests need a UTF-8 aware locale configured
  env.LANG = "C.UTF-8";

  meta = with lib; {
    description = "Collection of utilities for indexing and searching Maildirs";
    license = licenses.gpl3Plus;
    homepage = "https://www.djcbsoftware.nl/code/mu/";
    changelog = "https://github.com/djcb/mu/releases/tag/v${version}";
    maintainers = with maintainers; [
      antono
      chvp
      peterhoeg
    ];
    mainProgram = "mu";
    platforms = platforms.unix;
  };
}
