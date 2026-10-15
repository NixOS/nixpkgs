{
  fetchurl,
  lib,
  stdenv,
  guile,
  guile-lib,
  libffi,
  pkg-config,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "g-wrap";
  version = "1.9.15";

  src = fetchurl {
    url = "mirror://savannah/g-wrap/g-wrap-${finalAttrs.version}.tar.gz";
    sha256 = "0ak0bha37dfpj9kmyw1r8fj8nva639aw5xr66wr5gd3l1rqf5xhg";
  };

  # https://lists.gnu.org/r/guix-patches/2022-11/msg01596.html
  postPatch = ''
    substituteInPlace configure \
      --replace-fail "2.2 2.0" "3.0 2.2 2.0"
    substituteInPlace guile/g-wrap/guile-runtime.c \
      --replace-fail "scm_class_top" 'scm_c_public_ref ("oop goops", "<top>")' \
      --replace-fail "scm_class_method" 'scm_c_public_ref ("oop goops", "<method>")' \
      --replace-fail "scm_class_generic" 'scm_c_public_ref ("oop goops", "<generic>")' \
      --replace-fail "scm_memory_error(func_name)" "scm_report_out_of_memory ()"
  '';

  nativeBuildInputs = [ pkg-config ];

  # Note: Glib support is optional, but it's quite useful (e.g., it's used by
  # Guile-GNOME).
  buildInputs = [
    guile
    glib
    guile-lib
  ];

  propagatedBuildInputs = [ libffi ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  doCheck = true;

  meta = {
    description = "Wrapper generator for Guile";
    mainProgram = "g-wrap-config";
    longDescription = ''
      G-Wrap is a tool (and Guile library) for generating function wrappers for
      inter-language calls.  It currently only supports generating Guile
      wrappers for C functions.
    '';
    homepage = "https://www.nongnu.org/g-wrap/";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
