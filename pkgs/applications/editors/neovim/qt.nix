{ stdenv, fetchFromGitHub, cmake, qt5, pythonPackages, libmsgpack
, makeWrapper, neovim
}:

let # not very usable ATM
  version = "0pre-2015-10-18";
in
stdenv.mkDerivation {
  name = "neovim-qt-${version}";

  src = fetchFromGitHub {
    repo = "neovim-qt";
    owner = "equalsraf";
    rev = "03236e2";
    sha256 = "0hhwpnj7yfqdk7yiwrq0x6n4xx30brj9clxmxx796421rlcrxypq";
  };

  # It tries to download libmsgpack; let's use ours.
  postPatch = let use-msgpack = ''
    cmake_minimum_required(VERSION 2.8.11)
    project(neovim-qt-deps)

    # Similar enough to FindMsgpack
    set(MSGPACK_INCLUDE_DIRS ${libmsgpack}/include PARENT_SCOPE)
    set(MSGPACK_LIBRARIES msgpack PARENT_SCOPE)
  '';
    in "echo '${use-msgpack}' > third-party/CMakeLists.txt";

  buildInputs = with pythonPackages; [
    cmake qt5.qtbase
    python msgpack jinja2 libmsgpack
    makeWrapper
  ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p "$out/bin"
    mv ./bin/nvim-qt "$out/bin/"
    wrapProgram "$out/bin/nvim-qt" --prefix PATH : "${neovim}/bin"
  '';

  meta = with stdenv.lib; {
    description = "A prototype Qt5 GUI for neovim";
    license = licenses.isc;
    inherit (neovim.meta) platforms;
  };
}
