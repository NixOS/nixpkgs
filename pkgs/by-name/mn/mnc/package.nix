{
  lib,
  buildGoModule,
  fetchFromSourcehut,
}:

buildGoModule rec {
  pname = "mnc";
  version = "0.5";

  vendorHash = "sha256-H0KmGTWyjZOZLIEWophCwRYPeKLxBC050RI7cMXNbPs=";

  src = fetchFromSourcehut {
    owner = "~anjan";
    repo = "mnc";
    rev = version;
    sha256 = "sha256-eCj7wmHxPF2j2x4yHKN7TE122TCv1++azgdoQArabBM=";
  };

  meta = with lib; {
    description = "Opens the user's crontab and echos the time when the next cronjob will be ran";
    homepage = "https://git.sr.ht/~anjan/mnc";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wentam ];
    mainProgram = "mnc";
  };
}
