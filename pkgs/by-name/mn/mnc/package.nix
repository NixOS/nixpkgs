{
  lib,
  buildGoModule,
  fetchFromSourcehut,
}:

buildGoModule (finalAttrs: {
  pname = "mnc";
  version = "0.5";

  vendorHash = "sha256-H0KmGTWyjZOZLIEWophCwRYPeKLxBC050RI7cMXNbPs=";

  src = fetchFromSourcehut {
    owner = "~anjan";
    repo = "mnc";
    rev = finalAttrs.version;
    sha256 = "sha256-eCj7wmHxPF2j2x4yHKN7TE122TCv1++azgdoQArabBM=";
  };

  meta = {
    description = "Opens the user's crontab and echos the time when the next cronjob will be ran";
    homepage = "https://git.sr.ht/~anjan/mnc";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ wentam ];
    mainProgram = "mnc";
  };
})
