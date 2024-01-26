{ lib
, clangStdenv
, cmake
, fetchFromGitHub
, fetchpatch
# Libraries
, argparse
, cling
, cppzmq
, libuuid
, ncurses
, openssl
, pugixml
, xeus
, xeus-zmq
, xtl
, zeromq
, zlib
# Settings
, debug ? false
}:

let
  # Nixpkgs moved to argparse 3.x, but we need ~2.9
  argparse_2_9 = argparse.overrideAttrs (oldAttrs: {
    version = "2.9";

    src = fetchFromGitHub {
      owner = "p-ranav";
      repo = "argparse";
      rev = "v2.9";
      sha256 = "sha256-vbf4kePi5gfg9ub4aP1cCK1jtiA65bUS9+5Ghgvxt/E=";
    };
  });

in

clangStdenv.mkDerivation rec {
  pname = "xeus-cling";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "QuantStack";
    repo = "xeus-cling";
    rev = "${version}";
    hash = "sha256-OfZU+z+p3/a36GntusBfwfFu3ssJW4Fu7SV3SMCoo1I=";
  };

  patches = [
    ./0001-Fix-bug-in-extract_filename.patch
    ./0002-Don-t-pass-extra-includes-configure-this-with-flags.patch
    (fetchpatch {
      name = "0002-Use-llvm-from-cling.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0002-Use-llvm-from-cling.patch?h=xeus-cling&id=294d0aa6648c0f8a95fd0435c993130627059934";
      hash = "sha256-z3KUYMEc4RqLwzbb4hC9qBRBYsB1jtLIRt8fWb3zj5k=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    argparse_2_9
    cling.unwrapped
    cppzmq
    libuuid
    ncurses
    openssl
    pugixml
    xeus
    xeus-zmq
    xtl
    zeromq
    zlib
  ];

  cmakeFlags = lib.optionals debug [
    "-DCMAKE_BUILD_TYPE=Debug"
  ];

  dontStrip = debug;

  meta = {
    description = "Jupyter kernel for the C++ programming language";
    homepage = "https://github.com/jupyter-xeus/xeus-cling";
    maintainers = with lib.maintainers; [ thomasjm ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
}
