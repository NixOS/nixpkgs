with import ../../../. { };

mkShell {
  packages = [
    rustc
    cargo
    clippy
    rustfmt
  ] ++ lib.optional stdenv.isDarwin libiconv;
}
