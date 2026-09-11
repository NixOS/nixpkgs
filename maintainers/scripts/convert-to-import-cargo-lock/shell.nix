{
  pkgs ? import ../../.. { },
}:
let
  inherit (pkgs) lib stdenv mkShell;
in
mkShell {
  packages =
    with pkgs;
    [
      rustc
      cargo
      clippy
      rustfmt
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin pkgs.libiconv;
}
