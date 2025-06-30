{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hebcal";
  version = "5.9.2";

  src = fetchFromGitHub {
    owner = "hebcal";
    repo = "hebcal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6iyltrnA1pLtTUg0AUIp0yciN53oeoLE88dAbTxBK6I=";
  };

  vendorHash = "sha256-azKie/qJUmRSVgkfqsL04NpnePx9ToUPjz6RUOFRdUw=";

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
