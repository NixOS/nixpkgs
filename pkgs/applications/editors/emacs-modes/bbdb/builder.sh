source "$stdenv/setup"

unpackPhase &&						\
cd bbdb-*.* &&						\
./configure --prefix="$out"				\
            --with-package-dir="$out/lib/site-emacs" &&	\
make && make install-pkg
