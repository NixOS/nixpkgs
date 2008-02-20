source "$stdenv/setup" || exit 1

unpackPhase &&							\
cd bbdb-*.* &&							\
./configure --prefix="$out"					\
            --with-package-dir="$out/share/emacs/site-lisp" &&	\
make && make install-pkg
