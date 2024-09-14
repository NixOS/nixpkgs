pkgs:

self: super:

let
  libExt = pkgs.stdenv.hostPlatform.extensions.sharedLibrary;
in
{
  # TODO delete this when we get upstream fix https://debbugs.gnu.org/cgi/bugreport.cgi?bug=73241
  eglot = super.eglot.overrideAttrs (old: {
    postInstall =
      old.postInstall or ""
      + ''
        local info_file=eglot.info
        pushd $out/share/emacs/site-lisp/elpa/eglot-*
        # specify output info file to override the one defined in eglot.texi
        makeinfo --output=$info_file eglot.texi
        install-info $info_file dir
        popd
      '';
  });

  # native compilation for tests/seq-tests.el never ends
  # delete tests/seq-tests.el to workaround this
  seq = super.seq.overrideAttrs (old: {
    dontUnpack = false;
    postUnpack =
      old.postUnpack or ""
      + "\n"
      + ''
        local content_directory=$(echo seq-*)
        rm --verbose $content_directory/tests/seq-tests.el
        src=$PWD/$content_directory.tar
        tar --create --verbose --file=$src $content_directory
      '';
  });

  xeft = super.xeft.overrideAttrs (old: {
    dontUnpack = false;
    buildInputs = old.buildInputs or [ ] ++ [ pkgs.xapian ];
    buildPhase =
      old.buildPhase or ""
      + ''
        $CXX -shared -o xapian-lite${libExt} xapian-lite.cc $NIX_CFLAGS_COMPILE -lxapian
      '';
    postInstall =
      old.postInstall or ""
      + "\n"
      + ''
        outd=$out/share/emacs/site-lisp/elpa/xeft-*
        install -m444 -t $outd xapian-lite${libExt}
        rm $outd/xapian-lite.cc $outd/emacs-module.h $outd/emacs-module-prelude.h $outd/demo.gif $outd/Makefile
      '';
  });
}
