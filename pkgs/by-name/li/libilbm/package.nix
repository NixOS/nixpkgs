{
  stdenv,
  fetchFromGitHub,
  lib,
  libiff,
  autoreconfHook,
  pkg-config,
  help2man,
}:

stdenv.mkDerivation {
  pname = "libilbm";
  version = "0-unstable-2024-03-02";
  src = fetchFromGitHub {
    owner = "svanderburg";
    repo = "libilbm";
    rev = "586f5822275ef5780509a851cb90c7407b2633d9";
    sha256 = "sha256-EcsrspL/N40yFE15UFWGienpJHhoq1zd8zZe6x4nK6o=";
  };
  buildInputs = [ libiff ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    help2man
  ];
  meta = with lib; {
    description = "Parser for the ILBM: IFF Interleaved BitMap format";
    longDescription = ''
      libilbm is a portable parser library built on top of libiff,
      for ILBM: IFF Interleaved BitMap format, which is used by programs
      such as Deluxe Paint and Graphicraft to read and write images.
    '';
    homepage = "https://github.com/svanderburg/libilbm";
    maintainers = with maintainers; [ _414owen ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
