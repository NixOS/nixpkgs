{ stdenv, fetchFromGitHub, cmake, doxygen, makeWrapper
, libmsgpack, neovim, pythonPackages, qtbase }:

stdenv.mkDerivation rec {
  name = "neovim-qt-${version}";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner  = "equalsraf";
    repo   = "neovim-qt";
    rev    = "v${version}";
    sha256 = "1bfni38l7cs0wbd9c6hgz2jfc8h3ixmg94izdvydm8j7amdz0cb6";
  };

  cmakeFlags = [
    "-DMSGPACK_INCLUDE_DIRS=${libmsgpack}/include"
    "-DMSGPACK_LIBRARIES=${libmsgpack}/lib/libmsgpackc.so"
  ];

  # The following tests FAILED:
  #       2 - tst_neovimconnector (Failed)
  #       3 - tst_callallmethods (Failed)
  #       4 - tst_encoding (Failed)
  #
  # Tests failed when upgraded to neovim 0.2.0
  doCheck = false;

  buildInputs = with pythonPackages; [
    neovim qtbase libmsgpack
  ] ++ (with pythonPackages; [
    jinja2 msgpack python
  ]);

  nativeBuildInputs = [ cmake doxygen makeWrapper ];

  enableParallelBuilding = true;

  preConfigure = ''
    # avoid cmake trying to download libmsgpack
    echo "" > third-party/CMakeLists.txt
    # we rip out the gui test as spawning a GUI fails in our build environment
    sed -i '/^add_xtest_gui/d' test/CMakeLists.txt
  '';

  postInstall = ''
    wrapProgram "$out/bin/nvim-qt" \
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
