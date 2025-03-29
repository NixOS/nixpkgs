{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "catimg";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "posva";
    repo = "catimg";
    rev = version;
    sha256 = "0a2dswbv4xddb2l2d55hc43lzvjwrjs5z9am7v6i0p0mi2fmc89s";
  };

  nativeBuildInputs = [ cmake ];
  env = lib.optionalAttrs (stdenv.hostPlatform.libc == "glibc") {
    CFLAGS = "-D_DEFAULT_SOURCE";
  };

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/posva/catimg";
    description = "Insanely fast image printing in your terminal";
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
    mainProgram = "catimg";
  };

}
