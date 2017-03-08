{ stdenv, fetchFromGitHub, cmake, doxygen
, libmsgpack, makeQtWrapper, neovim, pythonPackages, qtbase }:

stdenv.mkDerivation rec {
  name = "neovim-qt-${version}";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner  = "equalsraf";
    repo   = "neovim-qt";
    rev    = "v${version}";
    sha256 = "1q706k400j5v9kans71yjz9p36ran2lpz29m4vjzj920llksln3d";
  };

  cmakeFlags = [
    "-DMSGPACK_INCLUDE_DIRS=${libmsgpack}/include"
    "-DMSGPACK_LIBRARIES=${libmsgpack}/lib/libmsgpackc.so"
  ];

  doCheck = false; # 5 out of 7 fail

  buildInputs = with pythonPackages; [
    qtbase libmsgpack
  ] ++ (with pythonPackages; [
    jinja2 msgpack python
  ]);

  nativeBuildInputs = [ cmake doxygen makeQtWrapper ];

  enableParallelBuilding = true;

  # avoid cmake trying to download libmsgpack
  preConfigure = "echo \"\" > third-party/CMakeLists.txt";

  postInstall = ''
    wrapQtProgram "$out/bin/nvim-qt" \
      --prefix PATH : "${neovim}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Neovim client library and GUI, in Qt5";
    license = licenses.isc;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (neovim.meta) platforms;
    inherit version;
  };
}
