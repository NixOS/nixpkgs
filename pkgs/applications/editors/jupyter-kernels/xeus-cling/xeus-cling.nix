{
  lib,
  clangStdenv,
  cmake,
  fetchFromGitHub,
  llvmPackages_18,
  # Libraries
  argparse,
  cling,
  cppzmq,
  libuuid,
  ncurses,
  openssl,
  pugixml,
  xeus,
  xeus-zmq,
  xtl,
  zeromq,
  zlib,
  # Settings
  debug ? false,
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

  # Nixpkgs moved to xeus 5.2.0, but we need 3.2.0
  # https://github.com/jupyter-xeus/xeus-cling/issues/523
  xeus_3_2_0 = xeus.overrideAttrs (oldAttrs: {
    version = "3.2.0";

    src = fetchFromGitHub {
      owner = "jupyter-xeus";
      repo = "xeus";
      tag = "3.2.0";
      sha256 = "sha256-D/dJ0SHxTHJw63gHD6FRZS7O2TVZ0voIv2mQASEjLA8=";
    };

    buildInputs = oldAttrs.buildInputs ++ lib.singleton xtl;
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
    ./0003-Remove-unsupported-src-root-flag.patch
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    argparse_2_9
    cling.unwrapped
    cppzmq
    libuuid
    llvmPackages_18.llvm
    ncurses
    openssl
    pugixml
    xeus_3_2_0
    xeus-zmq
    xtl
    zeromq
    zlib
  ];

  cmakeBuildType = if debug then "Debug" else "Release";

  postPatch = ''
    substituteInPlace src/xmagics/executable.cpp \
      --replace-fail "getDataLayout" "getDataLayoutString"
    substituteInPlace src/xmagics/execution.cpp \
      --replace-fail "simplisticCastAs" "castAs"
    substituteInPlace src/xmime_internal.hpp \
      --replace-fail "code.str()" "code.str().str()"

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.4.3)" "cmake_minimum_required(VERSION 3.10)"
  '';

  dontStrip = debug;

  meta = {
    description = "Jupyter kernel for the C++ programming language";
    mainProgram = "xcpp";
    homepage = "https://github.com/jupyter-xeus/xeus-cling";
    maintainers = with lib.maintainers; [ thomasjm ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
}
