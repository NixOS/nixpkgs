{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hebcal";
  version = "5.9.1";

  src = fetchFromGitHub {
    owner = "hebcal";
    repo = "hebcal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IhN0n3qa+QlWtSxHyzm3muldsFFrkRzCwulgCcg50eA=";
  };

  vendorHash = "sha256-Rpg+PVXY01+diJnE26iZ/oJhVVSoLdM7nWJFmfXBuHc=";

  preBuild = ''
    make dcity.go
  '';

  doCheck = true;

  meta = {
    homepage = "https://hebcal.github.io";
    description = "Perpetual Jewish Calendar";
    longDescription = "Hebcal is a program which prints out the days in the Jewish calendar for a given Gregorian year. Hebcal is fairly flexible in terms of which events in the Jewish calendar it displays.";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.hhm ];
    platforms = lib.platforms.all;
    mainProgram = "hebcal";
  };
})
