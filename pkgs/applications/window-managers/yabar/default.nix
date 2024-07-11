{ callPackage, attrs ? {}, fetchpatch }:

let
  overrides = rec {
    version = "0.4.0";

    rev = version;
    sha256 = "1nw9dar1caqln5fr0dqk7dg6naazbpfwwzxwlkxz42shsc3w30a6";

    patches = [
      (fetchpatch {
        url = "https://github.com/geommer/yabar/commit/9779a5e04bd6e8cdc1c9fcf5d7ac31416af85a53.patch";
        sha256 = "1szhr3k1kq6ixgnp74wnzgfvgxm6r4zpc3ny2x2wzy6lh2czc07s";
      })
    ];

  } // attrs;
in callPackage ./build.nix overrides
