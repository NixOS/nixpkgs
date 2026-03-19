{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rwc";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "rwc";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-rB20XKprd8jPwvXYdjIEr3/8ygPGCDAgLKbHfw0EgPk=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Report when files are changed";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ somasis ];
    mainProgram = "rwc";
  };
})
