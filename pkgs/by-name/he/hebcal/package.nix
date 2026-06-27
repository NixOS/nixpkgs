{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hebcal";
  version = "5.12.3";

  src = fetchFromGitHub {
    owner = "hebcal";
    repo = "hebcal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Iu1gaIzZRPe+XIbouAfyeltS0uYvKuB17RoaTUGhmA8=";
  };

  vendorHash = null;

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
