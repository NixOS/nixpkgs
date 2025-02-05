{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  libpng,
  perl,
  perlPackages,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "icoutils";
  version = "0.32.3";

  src = fetchurl {
    url = "mirror://savannah/icoutils/icoutils-${version}.tar.bz2";
    sha256 = "1q66cksms4l62y0wizb8vfavhmf7kyfgcfkynil3n99s0hny1aqp";
  };

  patches = [
    # Fixes a linker failure with newer versions of ld64 due to not supporting nested archives.
    (fetchpatch {
      url = "https://git.savannah.nongnu.org/cgit/icoutils.git/patch/?id=aa3572119bfe34484025f37dbbc4d5070f735908";
      hash = "sha256-4YCI+SYT2bCBNegkpN5jcfi6gOeec65TmCABr98HHB4=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
  ];
  buildInputs = [
    libpng
    perl
  ];
  propagatedBuildInputs = [ perlPackages.LWP ];

  postPatch = ''
    patchShebangs extresso/extresso
    patchShebangs extresso/extresso.in
    patchShebangs extresso/genresscript
    patchShebangs extresso/genresscript.in
  '';

  preFixup = ''
    wrapProgram $out/bin/extresso --prefix PERL5LIB : $PERL5LIB
    wrapProgram $out/bin/genresscript --prefix PERL5LIB : $PERL5LIB
  '';

  meta = {
    homepage = "https://www.nongnu.org/icoutils/";
    description = "Set of programs to deal with Microsoft Windows(R) icon and cursor files";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ darwin;
  };
}
