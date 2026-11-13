{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  pixiewps,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reaver-wps-t6x";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "t6x";
    repo = "reaver-wps-fork-t6x";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-7g4ZRkyu0TIOUw68dSPP4RyIRyeq1GgUMYFVSQB8/1I=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    libpcap
    pixiewps
  ];

  sourceRoot = "${finalAttrs.src.name}/src";

  meta = {
    description = "Online and offline brute force attack against WPS";
    homepage = "https://github.com/t6x/reaver-wps-fork-t6x";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nico202 ];
  };
})
