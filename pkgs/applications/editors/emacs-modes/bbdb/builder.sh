source "$stdenv/setup" || exit 1

unpackPhase &&							\
cd bbdb-*.* && patchPhase &&					\
./configure --prefix="$out"					\
            --with-package-dir="$out/share/emacs/site-lisp" &&	\
make && make install-pkg &&					\
mkdir -p "$out/info" &&						\
make -C texinfo install-pkg &&					\
mv "$out/share/emacs/site-lisp/lisp/bbdb/"*			\
   "$out/share/emacs/site-lisp" &&				\
rm -rf "$out/share/emacs/site-lisp/lisp"
