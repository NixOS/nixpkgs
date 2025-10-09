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

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  meta = with lib; {
    description = "Smart pointer constructs for the (GNU) C programming language";
    homepage = "https://github.com/Snaipe/libcsptr";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.fragamus ];
  };
}
