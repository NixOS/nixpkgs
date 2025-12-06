{
  pkgs,
  lib,
  stdenv,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sqm-scripts";
  version = "1.6.0";
  src = pkgs.fetchFromGitHub {
    owner = "tohojo";
    repo = "sqm-scripts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GjboEi4AOYAkzMCSTEmLKNuowSbUgeRDukL87Q6xCw4=";
  };
  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];
  meta = {
    description = "Set of scripts using the Linux qdisc mechanism to configure traffic shaping and scheduling";
    homepage = "https://github.com/tohojo/sqm-scripts";
    changelog = "https://github.com/tohojo/sqm-scripts/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.clarkadamp ];
    mainProgram = "sqm";
    platforms = lib.platforms.linux;
  };
})
