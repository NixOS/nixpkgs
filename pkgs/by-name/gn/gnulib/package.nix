{
  lib,
  stdenv,
  fetchgit,
  python3,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "gnulib";
  version = "20241001";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/git/gnulib.git";
    rev = "0a01f6737dc5666c730bdfe6a038da53a4156cc2";
    hash = "sha256-kbmXnXXoaTPGwjUJvnHWCQFS2KGQ9fsjIyloNmkKdc4=";
  };

  postPatch = ''
    patchShebangs gnulib-tool.py
    substituteInPlace build-aux/{prefix-gnulib-mk,useless-if-before-free,update-copyright,gitlog-to-changelog,announce-gen} \
    --replace-fail 'exec perl' 'exec ${lib.getExe perl}'
  '';

  buildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/
    ln -s $out/lib $out/include
    ln -s $out/gnulib-tool $out/bin/
  '';

  # do not change headers to not update all vendored build files
  dontFixup = true;

  passthru = {
    # This patch is used by multiple other packages (currently:
    # gnused, gettext) which contain vendored copies of gnulib.
    # Without it, compilation will fail with error messages about
    # "__LDBL_REDIR1_DECL" or similar on platforms with longdouble
    # redirects (currently powerpc64).  Once all of those other
    # packages make a release with a newer gnulib we can drop this
    # patch.
    longdouble-redirect-patch = ./gnulib-longdouble-redirect.patch;
  };

  meta = with lib; {
    description = "Central location for code to be shared among GNU packages";
    homepage = "https://www.gnu.org/software/gnulib/";
    changelog = "https://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=blob;f=ChangeLog";
    license = licenses.gpl3Plus;
    mainProgram = "gnulib-tool";
    platforms = platforms.unix;
  };
}
