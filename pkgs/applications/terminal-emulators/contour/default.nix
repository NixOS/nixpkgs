{ lib, mkDerivation, fetchFromGitHub, cmake, pkg-config, freetype, libGL, pcre }:

mkDerivation rec {
  pname = "contour";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "christianparpart";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-P7t+M75ZWjFcGWngcbaurdit6e+pb0ILljimhYqW0NI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ freetype libGL pcre ];

  meta = with lib; {
    description = "Modern C++ Terminal Emulator";
    homepage = "https://github.com/christianparpart/contour";
    changelog = "https://github.com/christianparpart/contour/blob/HEAD/Changelog.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fortuneteller2k ];
    platforms = platforms.unix;
  };
}
