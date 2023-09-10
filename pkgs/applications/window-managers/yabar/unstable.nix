{ fetchpatch, playerctl, libxkbcommon, callPackage, attrs ? {} }:

let
  pkg = callPackage ./build.nix ({
    version = "unstable-2018-01-18";

    rev    = "c516e8e78d39dd2b339acadc4c175347171150bb";
    sha256 = "1p9lx78cayyn7qc2q66id2xfs76jyddnqv2x1ypsvixaxwcvqgdb";
  } // attrs);
in pkg.overrideAttrs (o: {
  buildInputs = o.buildInputs ++ [
    playerctl libxkbcommon
  ];

  makeFlags = o.makeFlags ++ [
    "PLAYERCTL=1"
  ];

  patches = (o.patches or []) ++ [
    (fetchpatch {
      url = "https://github.com/geommer/yabar/commit/008dc1420ff684cf12ce2ef3ac9d642e054e39f5.patch";
      sha256 = "1q7nd66ai6nr2m6iqxn55gvbr4r5gjc00c8wyjc3riv31qcbqbhv";
    })
  ];
})
