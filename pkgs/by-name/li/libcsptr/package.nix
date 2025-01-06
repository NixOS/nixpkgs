{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "libcsptr";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "libcsptr";
    rev = "v${version}";
    sha256 = "0i1498h2i6zq3fn3zf3iw7glv6brn597165hnibgwccqa8sh3ich";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Smart pointer constructs for the (GNU) C programming language";
    homepage = "https://github.com/Snaipe/libcsptr";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.fragamus ];
  };
}
