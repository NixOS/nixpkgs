{
  lib,
  autoreconfHook,
  docbook_xml_dtd_43,
  docbook_xsl,
  fetchFromGitHub,
  gettext,
  gmp,
  gtk-doc,
  libxslt,
  mpfr,
  pcre2,
  pkg-config,
  python3,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libbytesize";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libbytesize";
    rev = finalAttrs.version;
    hash = "sha256-scOnucn7xp6KKEtkpwfyrdzcntJF2l0h0fsQotcceLc=";
  };

  outputs = [
    "out"
    "dev"
    "devdoc"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    docbook_xml_dtd_43
    docbook_xsl
    gettext
    gtk-doc
    libxslt
    pkg-config
    python3
  ];

  buildInputs = [
    gmp
    mpfr
    pcre2
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/storaged-project/libbytesize";
    description = "Tiny library providing a C 'class' for working with arbitrary big sizes in bytes";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "bscalc";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
