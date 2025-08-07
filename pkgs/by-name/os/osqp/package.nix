{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "osqp";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "oxfordcontrol";
    repo = "osqp";
    tag = "v${version}";
    hash = "sha256-BOAytzJzHcggncQzeDrXwJOq8B3doWERJ6CKIVg1yJY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Quadratic programming solver using operator splitting";
    homepage = "https://osqp.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ taktoa ];
    platforms = platforms.all;
  };
}
