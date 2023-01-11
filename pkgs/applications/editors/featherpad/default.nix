{ lib, mkDerivation, cmake, hunspell, pkg-config, qttools, qtbase, qtsvg, qtx11extras
, fetchFromGitHub }:

mkDerivation rec {
  pname = "featherpad";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "FeatherPad";
    rev = "V${version}";
    sha256 = "sha256-deQDLcymci8x9QvVOfNwroZPvifovxV6+jT9Grl3sxA=";
  };

  nativeBuildInputs = [ cmake pkg-config qttools ];
  buildInputs = [ hunspell qtbase qtsvg qtx11extras ];

  meta = with lib; {
    description = "Lightweight Qt5 Plain-Text Editor for Linux";
    homepage = "https://github.com/tsujan/FeatherPad";
    platforms = platforms.linux;
    maintainers = [ maintainers.flosse ];
    license = licenses.gpl3Plus;
  };
}
