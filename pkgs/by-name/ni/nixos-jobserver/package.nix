{ acl
, fuse3
, pkg-config
, lib
, stdenv
}:

stdenv.mkDerivation {
  pname = "nixos-jobserver";
  version = "unstable-2021-11-14";

  src = ./nixos-jobserver.cpp;

  buildInputs = [ fuse3 ];
  nativeBuildInputs = [ pkg-config ];

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild

    (
      set -x
      $CXX -std=c++17 -c -Wall -Werror -O2 $(pkg-config --cflags fuse3) -o nixos-jobserver.o $src
      $CXX $(pkg-config --libs fuse3) -o nixos-jobserver nixos-jobserver.o
    )

    runHook postBuild
  '';

  installPhase = ''
    runHook preBuild

    install -D nixos-jobserver $out/bin/nixos-jobserver

    runHook postBuild
  '';

  meta = with lib; {
    platforms = platforms.linux;
  };
}
