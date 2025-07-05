{
  autoconf,
  automake,
  texinfo,
  fetchgit,
  guile-cairo,
}:

guile-cairo.overrideAttrs (s: {
  pname = "guile-cairo-next";
  version = "1.11.2-next";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/git/guile-cairo.git";
    rev = "fa2ff12e5e01966d5dcd8cfb7d5f29324b814223";
    hash = "sha256-yrI4VjMSFVvtxtY+JLrDXAYfCUAM3UkAFBSW5p8F5g8=";
  };
  nativeBuildInputs = [
    autoconf
    automake
    texinfo
  ] ++ s.nativeBuildInputs;

  preConfigure = ''
    autoreconf -fvi
  '';
})
