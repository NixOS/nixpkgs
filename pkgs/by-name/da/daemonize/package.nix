{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "daemonize";
  version = "1.7.8";

  src = fetchFromGitHub {
    owner = "bmc";
    repo = "daemonize";
    rev = "release-${version}";
    sha256 = "1e6LZXf/lK7sB2CbXwOg7LOi0Q8IBQNAa4d7rX0Ej3A=";
  };

  meta = {
    description = "Runs a command as a Unix daemon";
    homepage = "http://software.clapper.org/daemonize/";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; linux ++ freebsd ++ darwin;
    mainProgram = "daemonize";
  };
}
