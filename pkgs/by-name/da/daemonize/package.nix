{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      url = "https://github.com/bmc/daemonize/commit/eaf4746d47e171e7b8655690eb1e91fc216f2866.patch";
      hash = "sha256-vXvC31Z/nPLIr9DOrgbrlDdkS/IQtv7/p8JbzkfkX0M=";
    })
  ];

  meta = {
    description = "Runs a command as a Unix daemon";
    homepage = "http://software.clapper.org/daemonize/";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; linux ++ freebsd ++ darwin;
    mainProgram = "daemonize";
  };
}
