{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "osmctools";
  version = "0.9";

  src = fetchFromGitLab {
    owner = "osm-c-tools";
    repo = pname;
    rev = version;
    sha256 = "1m8d3r1q1v05pkr8k9czrmb4xjszw6hvgsf3kn9pf0v14gpn4r8f";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Command line tools for transforming Open Street Map files";
    homepage = [
      "https://wiki.openstreetmap.org/wiki/osmconvert"
      "https://wiki.openstreetmap.org/wiki/osmfilter"
      "https://wiki.openstreetmap.org/wiki/osmupdate"
    ];
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
    license = licenses.agpl3Only;
  };
}
