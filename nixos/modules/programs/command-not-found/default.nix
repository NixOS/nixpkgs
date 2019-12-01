{ stdenv, sqlite, pkgconfig,
  dbPath ? "/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite"
}:
# build with: nix-build -E '(import <nixpkgs> {}).callPackage ./. {}'
stdenv.mkDerivation {
  name = "command-not-found";
  src = ./src;
  buildInputs = [ sqlite ];
  nativeBuildInputs = [ pkgconfig ];
  installPhase = ''
    mkdir -p $out/bin
    $CXX -O2 -std=c++17 -Wall \
      -DDB_PATH=\"${dbPath}\" \
      -DNIX_SYSTEM=\"${stdenv.system}\" \
      $(pkg-config --cflags --libs sqlite3) \
      -o $out/bin/command-not-found \
      command-not-found.cpp
  '';
}
