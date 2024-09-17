{
  lib,
  fetchFromGitHub,
  gitUpdater,
  mkNoto,
}:

mkNoto rec {
  pname = "noto-znamenny-musical-notation";
  version = "1.003";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "znamenny";
    rev = "NotoZnamennyMusicalNotation-v${version}";
    hash = "sha256-hoe4KocblsEIP59lR+sntZMddMkor8gQAe2ZmKYpvPM=";
  };

  isVariable = false;
  fontConfig = "znamenny";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoZnamennyMusicalNotation-v"; };

  meta = {
    description = "Font that contains symbols for the Znamenny Chant musical notation";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Znamenny+Musical+Notation";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = lib.teams.notofonts.members;
  };
}
