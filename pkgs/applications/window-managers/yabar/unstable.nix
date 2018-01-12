{ playerctl, libxkbcommon, callPackage, attrs ? {} }:

let
  pkg = callPackage ./build.nix ({
    version = "unstable-2018-01-02";

    rev    = "d9f75933f1fdd7bec24bf7db104c7e1df2728b98";
    sha256 = "0ry2pgqsnl6cmvkhakm73cjqdnirkimldnmbngl6hbvggx32z8c9";
  } // attrs);
in pkg.overrideAttrs (o: {
  buildInputs = o.buildInputs ++ [
    playerctl libxkbcommon
  ];

  makeFlags = o.makeFlags ++ [
    "PLAYERCTL=1"
  ];
})
