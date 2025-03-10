{
  lib,
  stdenv,
  fetchurl,
  fltk13,
  ghostscript,
}:

stdenv.mkDerivation rec {
  pname = "flpsed";
  version = "0.7.3";

  src = fetchurl {
    url = "http://www.flpsed.org/${pname}-${version}.tar.gz";
    sha256 = "0vngqxanykicabhfdznisv82k5ypkxwg0s93ms9ribvhpm8vf2xp";
  };

  buildInputs = [ fltk13 ];

  postPatch = ''
    # replace the execvp call to ghostscript
    sed -e '/exec_gs/ {n; s|"gs"|"${lib.getBin ghostscript}/bin/gs"|}' \
        -i src/GsWidget.cxx
  '';

  configureFlags = [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
    "FLTKCONFIG=${lib.getExe' (lib.getDev fltk13) "fltk-config"}"
  ];

  meta = with lib; {
    description = "WYSIWYG PostScript annotator";
    homepage = "https://flpsed.org/flpsed.html";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "flpsed";
  };
}
