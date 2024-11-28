{
  lib,
  stdenv,
  fetchFromGitLab,
  autoconf,
  ncurses,
  pcre2,
  quilt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ccze";
  version = "0.2.1-8";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "ccze";
    rev = "debian/${finalAttrs.version}";
    hash = "sha256-sESbs+HTDRX9w7c+LYnzQoemPIxAtqk27IVSTtiAGEk=";
  };

  postPatch = ''
    QUILT_PATCHES=debian/patches quilt push -a
  '';

  nativeBuildInputs = [
    autoconf
    quilt
  ];

  buildInputs = [
    ncurses
    pcre2
  ];

  preConfigure = ''
    autoheader
    autoconf
  '';

  meta = with lib; {
    mainProgram = "ccze";
    description = "Fast, modular log colorizer";
    homepage = "https://salsa.debian.org/debian/ccze";
    changelog = "https://salsa.debian.org/debian/ccze/-/raw/master/debian/changelog?ref_type=heads";
    longDescription = ''
      Fast log colorizer written in C, intended to be a drop-in replacement for the Perl colorize tool.
      Includes plugins for a variety of log formats (Apache, Postfix, Procmail, etc.).
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      malyn
      philiptaron
    ];
    platforms = platforms.linux;
  };
})
