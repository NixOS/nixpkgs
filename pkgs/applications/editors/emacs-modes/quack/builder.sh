source "$stdenv/setup" || exit 1

emacsDir="$out/share/emacs/site-lisp"

ensureDir "$emacsDir" &&					\
cp "$src" "$emacsDir/quack.el" &&				\
emacs --batch -f batch-byte-compile "$emacsDir/quack.el"
