{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "sqm-scripts";
  version = "1.6.0";
  src = pkgs.fetchFromGitHub {
    owner = "tohojo";
    repo = "sqm-scripts";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GjboEi4AOYAkzMCSTEmLKNuowSbUgeRDukL87Q6xCw4=";
  };
  installPhase = ''
    mkdir -p $out
    DESTDIR=$out PREFIX= make -e install
  '';
  meta = {
    description = "sqm-scripts uses the Linux qdisc mechanism to configure traffic shaping and scheduling";
    homepage = "https://github.com/tohojo/sqm-scripts";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.clarkadamp ];
  };
})
