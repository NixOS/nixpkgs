{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "libutp";
  version = "0-unstable-2017-01-02";

  src = fetchFromGitHub {
    # Use transmission fork from post-3.3-transmission branch
    owner = "transmission";
    repo = "libutp";
    rev = "fda9f4b3db97ccb243fcbed2ce280eb4135d705b";
    sha256 = "CvuZLOBksIl/lS6LaqOIuzNvX3ihlIPjI3Eqwo7YJH0=";
  };

  # Compatibility with CMake < 3.5 has been removed from CMake.
  postPatch = ''
    substituteInPlace \
      CMakeLists.txt \
      --replace-fail \
      "cmake_minimum_required(VERSION 2.8)" \
      "cmake_minimum_required(VERSION 3.5)"
  '';

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "uTorrent Transport Protocol library";
    homepage = "https://github.com/transmission/libutp";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
