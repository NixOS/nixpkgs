{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openal,
  libvorbis,
  opusfile,
  libsndfile,
}:

stdenv.mkDerivation rec {
  pname = "alure2";
  version = "unstable-2020-02-06";

  src = fetchFromGitHub {
    owner = "kcat";
    repo = "alure";
    rev = "50f92fe528e77da82197fd947d1cf9b0a82a0c7d";
    sha256 = "1gmc1yfhwaj6lik0vn7zv8y23i05f4rw25v2jg34n856jcs02svx";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    openal
    libvorbis
    opusfile
    libsndfile
  ];

  meta = with lib; {
    description = "Utility library for OpenAL, providing a C++ API and managing common tasks that include file loading, caching, and streaming";
    homepage = "https://github.com/kcat/alure";
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ McSinyx ];
  };
}
