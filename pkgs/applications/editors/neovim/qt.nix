{ stdenv, fetchFromGitHub, cmake, qt5, pythonPackages, libmsgpack
, makeWrapper, neovim
}:

let # not very usable ATM
  version = "0.2.3";
in
stdenv.mkDerivation {
  name = "neovim-qt-${version}";

  src = fetchFromGitHub {
    owner = "equalsraf";
    repo = "neovim-qt";
    rev = "v${version}";
    sha256 = "0ichqph7nfw3934jf0sp81bqd376xna3f899cc2xg88alb4f16dv";
  };

  # It tries to download libmsgpack; let's use ours.
  postPatch = let use-msgpack = ''
    cmake_minimum_required(VERSION 2.8.11)
    project(neovim-qt-deps)

    # Similar enough to FindMsgpack
    set(MSGPACK_INCLUDE_DIRS ${libmsgpack}/include PARENT_SCOPE)
    set(MSGPACK_LIBRARIES msgpackc PARENT_SCOPE)
  '';
    in "echo '${use-msgpack}' > third-party/CMakeLists.txt";

  buildInputs = with pythonPackages; [
    cmake qt5.qtbase
    python msgpack jinja2 libmsgpack
    makeWrapper
  ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram "$out/bin/nvim-qt" --prefix PATH : "${neovim}/bin"
  '';

  meta = with stdenv.lib; {
    description = "A prototype Qt5 GUI for neovim";
    license = licenses.isc;
    inherit (neovim.meta) platforms;
  };
}
