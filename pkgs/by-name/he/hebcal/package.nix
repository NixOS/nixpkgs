{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hebcal";
  version = "5.9.0";

  src = fetchFromGitHub {
    owner = "hebcal";
    repo = "hebcal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JtabO3/IM7Mh6zzO6Jwth1axnwOxIn/a3GQO9x3EHLw=";
  };

  vendorHash = "sha256-PhJdUU+QivGuLwHuThL7c645mbAgl160sbZ8y7Dd02M=";

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
