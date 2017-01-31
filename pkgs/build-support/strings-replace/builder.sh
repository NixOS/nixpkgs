source "$stdenv/setup"


mkdir -p "$out/bin"
cp "$src/strings-replace" "$out/bin"
wrapProgram "$out/bin/strings-replace" \
    --prefix PATH : "${binutils}/bin" \
    --prefix PATH : "${coreutils}/bin" \
    --prefix PATH : "${gnugrep}/bin"
